// Edge Function: chat-tcc
// Проксі до OpenAI з обмеженням теми (тактична медицина),
// rate-limit 30 запитів/добу та збереженням історії у chat_messages.

import { createClient } from "@supabase/supabase-js";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const SUPABASE_ANON_KEY = Deno.env.get("SUPABASE_ANON_KEY")!;
const OPENAI_API_KEY = Deno.env.get("OPENAI_API_KEY")!;

const DAILY_LIMIT = 30;
const MODEL = "gpt-4o-mini";
const MAX_HISTORY_MESSAGES = 20; // 10 пар user/assistant

const SYSTEM_PROMPT = `Ти — ШІ-помічник з тактичної медицини TCCC/TECC та протоколу MARCH-PAWS.

ПРАВИЛА:
1. Відповідай ВИКЛЮЧНО на запитання з тактичної/військової медицини, першої домедичної допомоги та протоколу MARCH (Massive hemorrhage, Airway, Respiration, Circulation, Hypothermia).
2. Якщо запит поза цією темою — ввічливо відмов українською: "Я допомагаю лише з питань тактичної медицини. Будь ласка, сформулюй запитання, пов'язане з TCCC, MARCH або першою допомогою."
3. У кінці кожної відповіді (крім випадку відмови за темою) додавай дисклеймер новим абзацом:
"⚠️ Це навчальна інформація, а не медичний діагноз. У реальній ситуації негайно звертайся за професійною медичною допомогою."
4. Відповідай українською, стисло, структуровано (списки/кроки).`;

interface ChatMessage {
  role: "user" | "assistant" | "system";
  content: string;
}

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

function jsonResponse(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }
  if (req.method !== "POST") {
    return jsonResponse({ error: "Method not allowed" }, 405);
  }

  // 1. Authorization → userId
  const authHeader = req.headers.get("Authorization") ?? "";
  const jwt = authHeader.replace("Bearer ", "").trim();
  if (!jwt) return jsonResponse({ error: "Не авторизовано" }, 401);

  const supabaseAuth = createClient(SUPABASE_URL, SUPABASE_ANON_KEY, {
    global: { headers: { Authorization: `Bearer ${jwt}` } },
  });
  const { data: userData, error: userErr } = await supabaseAuth.auth.getUser(
    jwt,
  );
  if (userErr || !userData.user) {
    return jsonResponse({ error: "Не авторизовано" }, 401);
  }
  const userId = userData.user.id;

  // 2. Service-role клієнт для запису у chat_quota та chat_messages
  const admin = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

  // 3. Перевірка ліміту
  const today = new Date().toISOString().slice(0, 10);
  const { data: quotaRow } = await admin
    .from("chat_quota")
    .select("count")
    .eq("user_id", userId)
    .eq("quota_date", today)
    .maybeSingle();
  const usedToday = (quotaRow?.count as number | undefined) ?? 0;
  if (usedToday >= DAILY_LIMIT) {
    return jsonResponse({
      error:
        `Денний ліміт ${DAILY_LIMIT} запитів вичерпано. Спробуйте завтра.`,
      remainingToday: 0,
    }, 429);
  }

  // 4. Парсинг тіла
  let body: { messages?: ChatMessage[] } = {};
  try {
    body = await req.json();
  } catch {
    return jsonResponse({ error: "Невалідний JSON" }, 400);
  }
  const incoming = body.messages ?? [];
  const userMessage = incoming.length > 0 ? incoming[incoming.length - 1] : null;
  if (!userMessage || userMessage.role !== "user" || !userMessage.content?.trim()) {
    return jsonResponse({ error: "Порожнє повідомлення" }, 400);
  }

  // Обмежуємо історію
  const trimmedHistory = incoming.slice(-MAX_HISTORY_MESSAGES);
  const messagesForLLM: ChatMessage[] = [
    { role: "system", content: SYSTEM_PROMPT },
    ...trimmedHistory,
  ];

  // 5. OpenAI виклик
  let assistantContent = "";
  let tokensUsed: number | null = null;
  try {
    const openaiRes = await fetch("https://api.openai.com/v1/chat/completions", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${OPENAI_API_KEY}`,
      },
      body: JSON.stringify({
        model: MODEL,
        messages: messagesForLLM,
        temperature: 0.3,
        max_tokens: 600,
      }),
    });

    if (!openaiRes.ok) {
      const errText = await openaiRes.text();
      console.error("OpenAI error:", openaiRes.status, errText);
      return jsonResponse({
        error: "Помилка LLM-сервісу. Спробуйте пізніше.",
      }, 502);
    }

    const data = await openaiRes.json();
    assistantContent = data.choices?.[0]?.message?.content ?? "";
    tokensUsed = data.usage?.total_tokens ?? null;
  } catch (e) {
    console.error("OpenAI fetch failed:", e);
    return jsonResponse({ error: "Не вдалося звʼязатися з LLM" }, 502);
  }

  if (!assistantContent.trim()) {
    return jsonResponse({ error: "Порожня відповідь LLM" }, 502);
  }

  // 6. Збереження user + assistant + інкремент квоти
  try {
    await admin.from("chat_messages").insert([
      { user_id: userId, role: "user", content: userMessage.content },
      {
        user_id: userId,
        role: "assistant",
        content: assistantContent,
        tokens_used: tokensUsed,
      },
    ]);

    await admin.from("chat_quota").upsert(
      { user_id: userId, quota_date: today, count: usedToday + 1 },
      { onConflict: "user_id,quota_date" },
    );
  } catch (e) {
    console.error("DB persist failed:", e);
    // не падаємо — відповідь у користувача вже є
  }

  return jsonResponse({
    reply: assistantContent,
    remainingToday: DAILY_LIMIT - (usedToday + 1),
  });
});
