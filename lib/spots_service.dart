import 'dart:convert';
import 'package:floaty_client/api.dart' as api;
import 'package:http/http.dart' as http;

import 'CookieAuth.dart';
import 'constants.dart';
import 'model.dart' as model;

Future<List<api.Spot>> fetchSpots(int userId, CookieAuth cookieAuth) async {
  final apiClient = api.ApiClient(
    basePath: backendUrl,
    authentication: cookieAuth,
  );
  final spotsApi = api.SpotsApi(apiClient);

  try {
    final List<api.Spot>? response = await spotsApi.getSpots();

    if (response != null && response.isNotEmpty) {
      return response;
    } else {
      return [];
    }
  } catch (e) {
    print('Error fetching spots: $e');
    return [];
  }
}

Future<List<api.Spot>> fetchAllSpots(CookieAuth cookieAuth) async {
  final apiClient = api.ApiClient(
    basePath: backendUrl,
    authentication: cookieAuth,
  );
  final spotsApi = api.SpotsApi(apiClient);

  try {
    final List<api.Spot>? response = await spotsApi.getSpots();

    if (response != null && response.isNotEmpty) {
      return response;
    } else {
      return [];
    }
  } catch (e) {
    print('Error fetching all spots: $e');
    return [];
  }
}
