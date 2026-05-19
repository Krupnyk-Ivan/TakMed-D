-- Розширюємо профіль: аватар (URL) та навчальний трек.
alter table public.profiles
  add column if not exists avatar_url text,
  add column if not exists track text check (track in ('military', 'civilian'));

create index if not exists idx_profiles_track on public.profiles (track);
