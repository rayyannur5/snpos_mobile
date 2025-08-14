import 'package:get/get.dart';

class BaseApiProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = 'https://fit-vaguely-sloth.ngrok-free.app/api';
    httpClient.defaultContentType = 'application/json';
    httpClient.timeout = const Duration(seconds: 10);

    super.onInit();
  }

  Response createResponse(Response response) {
    if(response is Map) {
      return response;
    } else {
      return Response(
        statusCode: response.statusCode,
        body: {
          'message' : response.bodyString
        }
      );
    }
  }
}