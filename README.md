# floaty_frontend
Best paraglading flight logging app in the world.

## Getting Started
Lalala...

### Generating OpenAPI Specification code
Install 'openapi-generator', e.g. using brew.
In the project root, call
'''bash
openapi-generator generate \
-i ./lib/api/floaty-open-api.yml \
-g dart \
-o ./lib/generated \
--additional-properties=pubName=floaty_client
'''
This will generate the openapi models and api code in lib/generated.


Note the ugly work-around
class ApiClient {
  ApiClient(
      {this.basePath = 'http://localhost',
      this.authentication,
      Client? client}) {
    _client = client ?? Client();

    // This is needed to enable cookie management with a BrowserClient.
    // TODO: Look into it how to make this happen without overwriting generated code.
    if (_client is BrowserClient) {
      (_client as BrowserClient).withCredentials = true;
    }
  }

  in api-client.dart (generated code).

  and import 'package:http/browser_client.dart'; in api.dart.