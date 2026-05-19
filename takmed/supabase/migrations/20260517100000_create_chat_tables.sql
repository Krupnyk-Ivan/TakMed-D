-- Історія повідомлень користувача з ШІ-помічником
create table if not exists public.chat_messages (
    id uuid primary key default gen_random_uuid(),
    user_id uuid not null references auth.users(id) on delete cascade,
    role text not null check (role in ('user', 'assistant', 'system')),
    content text not null,
    tokens_used integer,
    created_at timestamptz not null default now()
);

create index if not exists idx_chat_messages_user_created
    on public.chat_messages (user_id, created_at desc);

-- Квота запитів на день (rate-limit)
create table if not exists public.chat_quota (
    user_id uuid not null references auth.users(id) on delete cascade,
    quota_date date not null,
    count integer not null default 0,
    primary key (user_id, quota_date)
);

alter table public.chat_messages enable row level security;
alter table public.chat_quota enable row level security;

drop policy if exists "Users read own messages" on public.chat_messages;
create policy "Users read own messages"
    on public.chat_messages for select
    using (auth.uid() = user_id);

drop policy if exists "Users insert own messages" on public.chat_messages;
create policy "Users insert own messages"
    on public.chat_messages for insert
    with check (auth.uid() = user_id);

drop policy if exists "Users delete own messages" on public.chat_messages;
create policy "Users delete own messages"
    on public.chat_messages for delete
    using (auth.uid() = user_id);

drop policy if exists "Users read own quota" on public.chat_quota;
create policy "Users read own quota"
    on public.chat_quota for select
    using (auth.uid() = user_id);
-- INSERT/UPDATE на chat_quota роблятиме виключно Edge Function із service_role
