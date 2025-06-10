import 'package:floaty_client/api.dart' as api;

import 'CookieAuth.dart';
import 'constants.dart';

Future<List<api.Glider>> fetchGliders(CookieAuth cookieAuth) async {
  final apiClient = api.ApiClient(
    basePath: backendUrl,
    authentication: cookieAuth,
  );
  final glidersApi = api.GlidersApi(apiClient);

  try {
    final List<api.Glider>? response = await glidersApi.getAllGliders();

    if (response != null && response.isNotEmpty) {
      return response;
    } else {
      return [];
    }
  } catch (e) {
    print('Error fetching gliders: $e');
    return [];
  }
}
