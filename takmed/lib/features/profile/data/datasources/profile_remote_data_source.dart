import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> fetchCurrentProfile();
  Future<ProfileModel> updateProfile(ProfileModel profile);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl(this._client);
  final SupabaseClient _client;

  @override
  Future<ProfileModel> fetchCurrentProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw AppAuthException(message: 'Користувача не авторизовано');
    }

    try {
      final data = await _client
          .from('profiles')
          .select('id, name, email, avatar_url, track')
          .eq('id', user.id)
          .single();

      return ProfileModel.fromMap(Map<String, dynamic>.from(data));
    } on PostgrestException catch (e) {
      throw AppAuthException(message: e.message, originalError: e);
    } catch (e) {
      throw AppAuthException(
        message: 'Не вдалося завантажити профіль: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw AppAuthException(message: 'Користувача не авторизовано');
    }

    try {
      final response = await _client
          .from('profiles')
          .update({
            'name': profile.name,
            'avatar_url': profile.avatarUrl,
            'track': profile.track,
          })
          .eq('id', user.id)
          .select('id, name, email, avatar_url, track')
          .single();

      return ProfileModel.fromMap(Map<String, dynamic>.from(response));
    } on PostgrestException catch (e) {
      throw AppAuthException(message: e.message, originalError: e);
    } catch (e) {
      throw AppAuthException(
        message: 'Не вдалося зберегти профіль: $e',
        originalError: e,
      );
    }
  }
}
