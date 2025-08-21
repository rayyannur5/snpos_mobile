import 'package:get/get.dart';
import 'package:snpos/app/config/constants.dart';

class BaseApiProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = AppConstants.apiUrl;
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