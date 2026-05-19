import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:takmed/admin/admin_di.dart';
import 'package:takmed/core/config/supabase_config.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() {
    adminGetIt.reset();
  });

  test('setupAdminDI should register necessary dependencies', () async {
    // Act
    await setupAdminDI();

    // Assert
    expect(adminGetIt.isRegistered<supabase.SupabaseClient>(), isTrue);
    expect(adminGetIt.isRegistered<FlutterSecureStorage>(), isTrue);
  });
}
