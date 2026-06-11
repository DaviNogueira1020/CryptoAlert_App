import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handler) {
  return (RequestContext context) async {
    final method = context.request.method;
    
    // Handle CORS preflight requests
    if (method == HttpMethod.options) {
      return Response(
        statusCode: 200,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
          'Access-Control-Allow-Headers': 'Content-Type, Authorization',
          'Content-Type': 'application/json',
        },
      );
    }

    // Process the request
    final response = await handler(context);

    // Add CORS headers to all responses
    return response.copyWith(
      headers: {
        ...response.headers,
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
      },
    );
  };
}
