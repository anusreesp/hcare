import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/controller/auth_controller.dart';

final flutterStorageProvider = Provider<Map<String, String>>((ref) {
  final authData = ref.watch(authProvider);
  if (authData is LoggedInState) {
    return authData.allData;
  } else {
    return {};
  }
});

class StorageKeys {
  static const tokenKey = 'token';
  static const uid = 'id';
  static const empId = 'empId';
}
