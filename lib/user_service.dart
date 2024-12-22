import 'package:http/http.dart' as http;
import 'dart:convert';

import 'constants.dart';
import 'model.dart';

Future<FloatyUser> fetchUserById(String userId) async {
  final String apiUrl = '$backendUrl/users/$userId';

  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    return FloatyUser.fromJson(json.decode(response.body));
  } else {
    // TODO (Matthäus): This is bad.
    throw Exception('Failed to load user');
  }
}
