import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../../../core/constants/app_strings.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/auth_user_model.dart';

/// Контракт віддаленого джерела даних авторизації.
abstract class AuthRemoteDataSource {
  /// Виконує вхід користувача.
  Future<AuthUserModel> signIn({
    required String email,
    required String password,
  });

  /// Виконує реєстрацію користувача.
  Future<AuthUserModel> signUp({
    required String email,
    required String password,
    required String name,
  });

  /// Відправляє запит скидання пароля.
  Future<void> resetPassword({required String email});

  /// Виконує вихід користувача.
  Future<void> logout();

  /// Оновлює маркер доступу.
  Future<AuthUserModel> refreshToken();
}

/// Реалізація віддаленого джерела даних авторизації через Supabase.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  /// Створює екземпляр data source.
  const AuthRemoteDataSourceImpl(this._supabaseClient);

  final supabase.SupabaseClient _supabaseClient;

  String _fallbackName(supabase.User user) {
    final metadataName = user.userMetadata?['name'] as String?;
    if (metadataName != null && metadataName.trim().isNotEmpty) {
      return metadataName.trim();
    }
    final email = user.email ?? '';
    if (email.contains('@')) {
      return email.split('@').first;
    }
    return 'User';
  }

  bool _isProfilesTableMissing(Object error) {
    if (error is! supabase.PostgrestException) {
      return false;
    }
    final message = error.message.toLowerCase();
    return message.contains("public.profiles") ||
        message.contains("could not find the table") ||
        message.contains("schema cache");
  }

  @override
  Future<AuthUserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        throw AppAuthException(message: AppStrings.invalidCredentials);
      }

      // Отримує додаткові дані користувача з профілю
      Map<String, dynamic>? profileData;
      try {
        profileData =
            await _supabaseClient
                .from('profiles')
                .select('name')
                .eq('id', user.id)
                .maybeSingle();
      } on supabase.PostgrestException catch (e) {
        if (!_isProfilesTableMissing(e)) {
          rethrow;
        }
      }

      return AuthUserModel(
        id: user.id,
        email: user.email ?? '',
        name: profileData?['name'] as String? ?? _fallbackName(user),
        token: response.session?.accessToken ?? '',
      );
    } on supabase.AuthException catch (e) {
      throw AppAuthException(message: e.message);
    } on supabase.PostgrestException catch (e) {
      throw AppAuthException(message: e.message, originalError: e);
    } catch (e) {
      throw AppAuthException(
        message: '${AppStrings.unexpectedAuthError}: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<AuthUserModel> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: <String, dynamic>{
          'name': name,
        },
      );

      final user = response.user;
      if (user == null) {
        throw AppAuthException(message: AppStrings.fieldRequired);
      }

      // Якщо сесія не створена — потрібне підтвердження email
      if (response.session == null) {
        throw AppAuthException(
          message: AppStrings.signUpSuccess,
        );
      }

      return AuthUserModel(
        id: user.id,
        email: user.email ?? '',
        name: name,
        token: response.session?.accessToken ?? '',
      );
    } on supabase.AuthException catch (e) {
      throw AppAuthException(message: e.message);
    } on supabase.PostgrestException catch (e) {
      throw AppAuthException(message: e.message, originalError: e);
    } catch (e) {
      throw AppAuthException(
        message: '${AppStrings.unexpectedAuthError}: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await _supabaseClient.auth.resetPasswordForEmail(email);
    } on supabase.AuthException catch (e) {
      throw AppAuthException(message: e.message);
    } on supabase.PostgrestException catch (e) {
      throw AppAuthException(message: e.message, originalError: e);
    } catch (e) {
      throw AppAuthException(
        message: '${AppStrings.unexpectedAuthError}: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _supabaseClient.auth.signOut();
    } on supabase.AuthException catch (e) {
      throw AppAuthException(message: e.message);
    } on supabase.PostgrestException catch (e) {
      throw AppAuthException(message: e.message, originalError: e);
    } catch (e) {
      throw AppAuthException(
        message: '${AppStrings.unexpectedAuthError}: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<AuthUserModel> refreshToken() async {
    try {
      final response = await _supabaseClient.auth.refreshSession();

      final user = response.user;
      if (user == null) {
        throw AppAuthException(message: AppStrings.unexpectedAuthError);
      }

      // Отримує додаткові дані користувача
      Map<String, dynamic>? profileData;
      try {
        profileData =
            await _supabaseClient
                .from('profiles')
                .select('name')
                .eq('id', user.id)
                .maybeSingle();
      } on supabase.PostgrestException catch (e) {
        if (!_isProfilesTableMissing(e)) {
          rethrow;
        }
      }

      return AuthUserModel(
        id: user.id,
        email: user.email ?? '',
        name: profileData?['name'] as String? ?? _fallbackName(user),
        token: response.session?.accessToken ?? '',
      );
    } on supabase.AuthException catch (e) {
      throw AppAuthException(message: e.message);
    } on supabase.PostgrestException catch (e) {
      throw AppAuthException(message: e.message, originalError: e);
    } catch (e) {
      throw AppAuthException(
        message: '${AppStrings.unexpectedAuthError}: $e',
        originalError: e,
      );
    }
  }
}
