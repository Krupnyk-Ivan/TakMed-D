create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  name text not null default '',
  email text unique,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
