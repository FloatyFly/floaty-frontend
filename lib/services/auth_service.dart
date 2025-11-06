import 'package:floaty_client/api.dart' as api;

import '../config/constants.dart';

Future<void> logout() async {
  print('logout() function called');
  final apiClient = api.ApiClient(
    basePath: backendUrl,
  );

  final usersApi = api.AuthApi(apiClient);

  try {
    print('Calling backend logout API at: $backendUrl/auth/logout');
    await usersApi.logoutUser();
    print('Backend logout API call successful');
  } catch (e) {
    print('Backend logout API failed with error: $e');
    throw Exception('Failed to logout user: $e');
  }
}
