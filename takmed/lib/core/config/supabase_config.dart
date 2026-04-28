/// Конфігурація Supabase для застосунку TacMed.
class SupabaseConfig {
  /// URL Supabase проекту.
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://dcjcjywtnrvvclpgrdyp.supabase.co',
  );

  /// Анонімний ключ доступу Supabase.
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRjamNqeXd0bnJ2dmNscGdyZHlwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY4NTcwNTYsImV4cCI6MjA5MjQzMzA1Nn0.dWR2QL3VFVGoXqU-WjZELTo2d9LbXT3wVKYLXX_8mXg',
  );

  /// Показує, чи налаштовано конфігурацію
  static bool get isConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
