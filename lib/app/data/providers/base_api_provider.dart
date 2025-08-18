import 'package:get/get.dart';

class BaseApiProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = 'http://34.30.207.212/api';
    httpClient.defaultContentType = 'application/json';
    httpClient.timeout = const Duration(seconds: 10);

    super.onInit();
  }

  Response createResponse(Response response) {

    if(response.body is Map) {
      return response;
    } else {
      return Response(
        statusCode: response.statusCode,
        body: {
          'message' : response.bodyString ?? 'Terjadi kesalahan'
        }
      );
    }
  }
}