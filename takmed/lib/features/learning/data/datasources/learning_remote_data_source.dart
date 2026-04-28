import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../models/learning_sync_models.dart';

abstract class LearningRemoteDataSource {
  Future<List<RemoteCourseDto>> fetchCoursesUpdatedAfter(
    DateTime? updatedAfter,
  );

  Future<List<RemoteLessonDto>> fetchLessonsUpdatedAfter(
    DateTime? updatedAfter,
  );

  Future<List<RemoteUserProgressDto>> fetchUserProgressUpdatedAfter(
    String userId,
    DateTime? updatedAfter,
  );

  Future<void> upsertUserProgress(List<RemoteUserProgressDto> rows);
}

class LearningRemoteDataSourceImpl implements LearningRemoteDataSource {
  const LearningRemoteDataSourceImpl(this._supabaseClient);

  final supabase.SupabaseClient _supabaseClient;

  @override
  Future<List<RemoteCourseDto>> fetchCoursesUpdatedAfter(
    DateTime? updatedAfter,
  ) async {
    final dynamic response;
    if (updatedAfter != null) {
      response = await _supabaseClient
          .from('courses')
          .select()
          .gt('updated_at', updatedAfter.toUtc().toIso8601String())
          .order('order_index', ascending: true);
    } else {
      response = await _supabaseClient
          .from('courses')
          .select()
          .order('order_index', ascending: true);
    }

    final rows = _toMapList(response);
    return rows.map(RemoteCourseDto.fromMap).toList();
  }

  @override
  Future<List<RemoteLessonDto>> fetchLessonsUpdatedAfter(
    DateTime? updatedAfter,
  ) async {
    final dynamic response;
    if (updatedAfter != null) {
      response = await _supabaseClient
          .from('lessons')
          .select()
          .gt('updated_at', updatedAfter.toUtc().toIso8601String())
          .order('course_remote_id', ascending: true)
          .order('order_index', ascending: true);
    } else {
      response = await _supabaseClient
          .from('lessons')
          .select()
          .order('course_remote_id', ascending: true)
          .order('order_index', ascending: true);
    }

    final rows = _toMapList(response);
    return rows.map(RemoteLessonDto.fromMap).toList();
  }

  @override
  Future<List<RemoteUserProgressDto>> fetchUserProgressUpdatedAfter(
    String userId,
    DateTime? updatedAfter,
  ) async {
    final dynamic response;
    if (updatedAfter != null) {
      response = await _supabaseClient
          .from('user_progress')
          .select()
          .eq('user_id', userId)
          .gt('updated_at', updatedAfter.toUtc().toIso8601String())
          .order('updated_at', ascending: true);
    } else {
      response = await _supabaseClient
          .from('user_progress')
          .select()
          .eq('user_id', userId)
          .order('updated_at', ascending: true);
    }

    final rows = _toMapList(response);
    return rows.map(RemoteUserProgressDto.fromMap).toList();
  }

  @override
  Future<void> upsertUserProgress(List<RemoteUserProgressDto> rows) async {
    if (rows.isEmpty) {
      return;
    }

    final payload = rows.map((row) => row.toUpsertMap()).toList();
    await _supabaseClient
        .from('user_progress')
        .upsert(payload, onConflict: 'user_id,lesson_remote_id');
  }

  List<Map<String, dynamic>> _toMapList(dynamic response) {
    if (response is List) {
      return response
          .map((row) => Map<String, dynamic>.from(row as Map))
          .toList();
    }
    return const <Map<String, dynamic>>[];
  }
}
