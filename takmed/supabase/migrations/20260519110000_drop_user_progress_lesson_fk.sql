-- Прибираємо FK constraint щоб user_progress міг зберігати прогрес
-- по seed-уроках (які існують тільки локально, не в Supabase).
-- Референційна цілісність підтримується на рівні застосунку.
alter table public.user_progress
  drop constraint if exists user_progress_lesson_remote_id_fkey;
