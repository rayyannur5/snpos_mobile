import 'package:get/get.dart';
import 'package:snpos/app/data/providers/base_api_provider.dart';

class DetailAbsensiProvider extends BaseApiProvider {

  Future<Response> detailAttendance(String token, String id) async {
    Response response = await get(
      '/attendance/$id',
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    return createResponse(response);
  }


}
