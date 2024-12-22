import 'package:floaty_client/api.dart' as api;

import 'CookieAuth.dart';
import 'constants.dart';

Future<void> logout(int userId, CookieAuth cookieAuth) async {
  final apiClient = api.ApiClient(basePath: backendUrl, authentication: cookieAuth);

  final usersApi = api.AuthApi(apiClient);

  try {
    await usersApi.logoutUser(userId);
  } catch (e) {
    throw Exception('Failed to logout user: $e');
  }
}