-- Таблиця спроб проходження тестів (Quiz Attempts)
create table if not exists public.quiz_attempts (
    id uuid primary key default gen_random_uuid(),
    user_id uuid not null references auth.users(id) on delete cascade,
    -- lesson_remote_id БЕЗ references щоб підтримувати seed-уроки
    lesson_remote_id text,
    total_questions integer not null,
    correct_answers integer not null,
    score_percent integer not null,
    earned_xp integer not null default 0,
    weak_topics jsonb not null default '[]'::jsonb,
    attempted_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

-- Індекс для швидкої вибірки історії користувача
create index if not exists idx_quiz_attempts_user_date
    on public.quiz_attempts (user_id, attempted_at desc);

-- Тригер оновлення updated_at
drop trigger if exists trg_quiz_attempts_updated_at on public.quiz_attempts;
create trigger trg_quiz_attempts_updated_at
before update on public.quiz_attempts
for each row execute function public.set_updated_at();

-- RLS
alter table public.quiz_attempts enable row level security;

drop policy if exists "Users can view own quiz attempts" on public.quiz_attempts;
create policy "Users can view own quiz attempts"
    on public.quiz_attempts
    for select
    using (auth.uid() = user_id);

drop policy if exists "Users can insert own quiz attempts" on public.quiz_attempts;
create policy "Users can insert own quiz attempts"
    on public.quiz_attempts
    for insert
    with check (auth.uid() = user_id);

drop policy if exists "Users can update own quiz attempts" on public.quiz_attempts;
create policy "Users can update own quiz attempts"
    on public.quiz_attempts
    for update
    using (auth.uid() = user_id)
    with check (auth.uid() = user_id);

drop policy if exists "Users can delete own quiz attempts" on public.quiz_attempts;
create policy "Users can delete own quiz attempts"
    on public.quiz_attempts
    for delete
    using (auth.uid() = user_id);
