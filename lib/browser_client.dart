import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;

class Client {
  static final http.Client _instance = BrowserClient();

  http.Client getInstance() {
    (_instance as BrowserClient).withCredentials = true;
    return _instance;
  }
}