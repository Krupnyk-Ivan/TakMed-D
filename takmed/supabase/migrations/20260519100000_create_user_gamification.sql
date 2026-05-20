-- Таблиця для хмарного збереження гейміфікації (XP, стрік, досягнення).
-- Track зберігається в profiles.track (міграція 20260516120000).

create table if not exists public.user_gamification (
  user_id             uuid        primary key references auth.users(id) on delete cascade,
  total_xp            integer     not null default 0,
  current_streak      integer     not null default 0,
  best_streak         integer     not null default 0,
  last_activity_date  timestamptz,
  -- JSON-об'єкт: { "achievement_id": "2024-01-15T10:30:00.000Z", ... }
  unlocked_achievements jsonb     not null default '{}',
  freezes_available   integer     not null default 0,
  updated_at          timestamptz not null default now()
);

alter table public.user_gamification enable row level security;

-- Кожен користувач бачить і змінює тільки свій рядок
create policy "Users manage own gamification"
  on public.user_gamification
  for all
  using  (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- Тригер: автоматично оновлює updated_at
create or replace function public.touch_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger trg_user_gamification_updated_at
  before update on public.user_gamification
  for each row execute function public.touch_updated_at();
