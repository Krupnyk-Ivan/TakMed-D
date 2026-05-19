import 'package:flutter_test/flutter_test.dart';
import 'package:takmed/features/auth/data/models/auth_user_model.dart';

void main() {
  const tAuthUserModel = AuthUserModel(
    id: 'test_id',
    email: 'test@example.com',
    name: 'Test User',
    token: 'test_token',
    role: 'admin',
  );

  test('should return a valid model from JSON with role', () {
    // arrange
    final Map<String, dynamic> jsonMap = {
      'id': 'test_id',
      'email': 'test@example.com',
      'name': 'Test User',
      'token': 'test_token',
      'role': 'admin',
    };
    
    // act
    final result = AuthUserModel.fromJson(jsonMap);
    
    // assert
    expect(result, tAuthUserModel);
    expect(result.role, 'admin');
  });

  test('should return a valid model from JSON without role (default to student)', () {
    // arrange
    final Map<String, dynamic> jsonMap = {
      'id': 'test_id',
      'email': 'test@example.com',
      'name': 'Test User',
      'token': 'test_token',
    };
    
    // act
    final result = AuthUserModel.fromJson(jsonMap);
    
    // assert
    expect(result.role, 'student');
  });

  test('should return a JSON map containing the proper data including role', () {
    // act
    final result = tAuthUserModel.toJson();
    
    // assert
    final expectedMap = {
      'id': 'test_id',
      'email': 'test@example.com',
      'name': 'Test User',
      'token': 'test_token',
      'role': 'admin',
    };
    expect(result, expectedMap);
  });
}
