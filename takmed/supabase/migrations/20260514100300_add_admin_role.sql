-- Додавання поля role до таблиці profiles
alter table public.profiles 
add column if not exists role text not null default 'student' check (role in ('student', 'admin'));

-- Допоміжна функція для перевірки ролі адміністратора (security definer для обходу RLS на самому profiles якщо потрібно)
create or replace function public.is_admin()
returns boolean
language sql security definer
as $$
  select exists (
    select 1 from public.profiles
    where id = auth.uid() and role = 'admin'
  );
$$;

-- Політики для адмінів на courses
drop policy if exists "Admins can insert courses" on public.courses;
create policy "Admins can insert courses"
    on public.courses for insert
    with check (public.is_admin());

drop policy if exists "Admins can update courses" on public.courses;
create policy "Admins can update courses"
    on public.courses for update
    using (public.is_admin())
    with check (public.is_admin());

drop policy if exists "Admins can delete courses" on public.courses;
create policy "Admins can delete courses"
    on public.courses for delete
    using (public.is_admin());

-- Політики для адмінів на lessons
drop policy if exists "Admins can insert lessons" on public.lessons;
create policy "Admins can insert lessons"
    on public.lessons for insert
    with check (public.is_admin());

drop policy if exists "Admins can update lessons" on public.lessons;
create policy "Admins can update lessons"
    on public.lessons for update
    using (public.is_admin())
    with check (public.is_admin());

drop policy if exists "Admins can delete lessons" on public.lessons;
create policy "Admins can delete lessons"
    on public.lessons for delete
    using (public.is_admin());
