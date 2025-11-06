import 'package:floaty_client/api.dart';

// Browsers handle cookies automatically, so this class is now a no-op
class CookieAuth implements Authentication {
  CookieAuth();

  @override
  Future<void> applyToParams(
    List<QueryParam> queryParams,
    Map<String, String> headerParams,
  ) async {
    // Browsers automatically include cookies in requests
    // No manual cookie handling needed
  }
}
