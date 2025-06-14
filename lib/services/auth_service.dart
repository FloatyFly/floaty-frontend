import 'package:floaty_client/api.dart' as api;

import '../config/CookieAuth.dart';
import '../config/constants.dart';

Future<void> logout(int userId, CookieAuth cookieAuth) async {
  final apiClient = api.ApiClient(
    basePath: backendUrl,
    authentication: cookieAuth,
  );

  final usersApi = api.AuthApi(apiClient);

  try {
    await usersApi.logoutUser();
  } catch (e) {
    throw Exception('Failed to logout user: $e');
  }
}
