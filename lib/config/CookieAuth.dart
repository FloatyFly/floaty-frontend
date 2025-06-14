import 'package:cookie_jar/cookie_jar.dart';
import 'package:floaty_client/api.dart';

import 'constants.dart';

class CookieAuth implements Authentication {
  final CookieJar cookieJar;

  CookieAuth(this.cookieJar);

  @override
  Future<void> applyToParams(
    List<QueryParam> queryParams,
    Map<String, String> headerParams,
  ) async {
    final uri = Uri.parse(backendUrl); // The URL your API is hosted at
    final cookies = await cookieJar.loadForRequest(uri);

    // Find the session token
    final sessionCookie = cookies.firstWhere(
      (cookie) => cookie.name == 'sessionToken',
      orElse: () => Cookie('sessionToken', ''),
    );

    if (sessionCookie.value.isNotEmpty) {
      headerParams.update(
        'Cookie',
        (existingCookie) =>
            '$existingCookie; sessionToken=${sessionCookie.value}',
        ifAbsent: () => 'sessionToken=${sessionCookie.value}',
      );
    }
  }

  Future<String> getCookieHeader() async {
    final cookies = await cookieJar.loadForRequest(
      Uri.parse('http://localhost'),
    );
    return cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');
  }
}
