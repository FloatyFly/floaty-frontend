import 'package:http/http.dart' as http;
import 'dart:convert';

import 'constants.dart';
import 'model.dart';


Future<User> fetchUserById(String userId) async {
  final String apiUrl = '$BASE_URL/users/$userId';

  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    return User.fromJson(json.decode(response.body));
  } else {
    // TODO (Matthäus): This is bad.
    throw Exception('Failed to load user');
  }
}