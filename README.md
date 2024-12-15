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
