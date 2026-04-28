create table if not exists public.courses (
    remote_id text primary key,
    title text not null,
    description text not null,
    track text not null check (track in ('military', 'civilian')),
    order_index integer not null,
    total_lessons integer not null default 0,
    updated_at timestamptz not null default now()
);

create table if not exists public.lessons (
    remote_id text primary key,
    course_remote_id text not null references public.courses(remote_id) on delete cascade,
    type text not null check (type in ('theory', 'video', 'quiz', 'checklist')),
    title text not null,
    content_json text not null,
    duration_seconds integer not null,
    order_index integer not null,
    xp_reward integer not null default 10,
    updated_at timestamptz not null default now()
);

create table if not exists public.user_progress (
    user_id uuid not null references auth.users(id) on delete cascade,
    lesson_remote_id text not null references public.lessons(remote_id) on delete cascade,
    score integer not null default 0 check (score >= 0 and score <= 100),
    attempts integer not null default 1,
    completed_at timestamptz not null default now(),
    weak_topics jsonb not null default '[]'::jsonb,
    updated_at timestamptz not null default now(),
    synced_at timestamptz,
    primary key (user_id, lesson_remote_id)
);

create index if not exists idx_courses_track_order
    on public.courses (track, order_index);

create index if not exists idx_lessons_course_order
    on public.lessons (course_remote_id, order_index);

create index if not exists idx_user_progress_user_updated
    on public.user_progress (user_id, updated_at desc);

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
    new.updated_at = now();
    return new;
end;
$$;

drop trigger if exists trg_courses_updated_at on public.courses;
create trigger trg_courses_updated_at
before update on public.courses
for each row execute function public.set_updated_at();

drop trigger if exists trg_lessons_updated_at on public.lessons;
create trigger trg_lessons_updated_at
before update on public.lessons
for each row execute function public.set_updated_at();

drop trigger if exists trg_user_progress_updated_at on public.user_progress;
create trigger trg_user_progress_updated_at
before update on public.user_progress
for each row execute function public.set_updated_at();

alter table public.courses enable row level security;
alter table public.lessons enable row level security;
alter table public.user_progress enable row level security;

drop policy if exists "Authenticated users can read courses" on public.courses;
create policy "Authenticated users can read courses"
    on public.courses
    for select
    using (auth.role() = 'authenticated');

drop policy if exists "Authenticated users can read lessons" on public.lessons;
create policy "Authenticated users can read lessons"
    on public.lessons
    for select
    using (auth.role() = 'authenticated');

drop policy if exists "Users can view own progress" on public.user_progress;
create policy "Users can view own progress"
    on public.user_progress
    for select
    using (auth.uid() = user_id);

drop policy if exists "Users can insert own progress" on public.user_progress;
create policy "Users can insert own progress"
    on public.user_progress
    for insert
    with check (auth.uid() = user_id);

drop policy if exists "Users can update own progress" on public.user_progress;
create policy "Users can update own progress"
    on public.user_progress
    for update
    using (auth.uid() = user_id)
    with check (auth.uid() = user_id);

drop policy if exists "Users can delete own progress" on public.user_progress;
create policy "Users can delete own progress"
    on public.user_progress
    for delete
    using (auth.uid() = user_id);
