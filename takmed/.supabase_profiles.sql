create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  name text not null default '',
  email text unique,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.profiles enable row level security;

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, name, email)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'name', split_part(coalesce(new.email, ''), '@', 1), 'User'),
    new.email
  )
  on conflict (id) do update
    set name = excluded.name,
        email = excluded.email,
        updated_at = now();
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

create policy if not exists "Users can view own profile"
  on public.profiles
  for select
  using (auth.uid() = id);

create policy if not exists "Users can insert own profile"
  on public.profiles
  for insert
  with check (auth.uid() = id);

create policy if not exists "Users can update own profile"
  on public.profiles
  for update
  using (auth.uid() = id)
  with check (auth.uid() = id);

create policy if not exists "Users can delete own profile"
  on public.profiles
  for delete
  using (auth.uid() = id);
