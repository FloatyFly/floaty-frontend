import 'package:http/http.dart' as http;
import 'dart:convert';

import 'model.dart';

// const BASE_URL = 'http://10.0.2.2:8080'; // use for debugging TODO: Make configurable
const BASE_URL = 'https://floaty-backend-floaty-backend.azuremicroservices.io';

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