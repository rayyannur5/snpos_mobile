import 'dart:io';

import 'package:get/get.dart';
import 'package:snpos/app/data/providers/base_api_provider.dart';

class MaintenanceProvider extends BaseApiProvider {

  Future<Response> getMaintenance(String token) async {
    Response response = await get('/maintenance/lists', headers: {'Authorization': 'Bearer $token'});
    return createResponse(response);
  }


  Future<Response> getMaintenanceRequest(String token) async {
    Response response = await get('/maintenance/items_and_outlets', headers: {'Authorization': 'Bearer $token'});
    return createResponse(response);
  }

  Future<Response> submitMaintenanceRequest(String token, int item_id, int outlet_id, String note, String? image) async {

    var form = {
      'item_id': item_id,
      'outlet_id': outlet_id,
      'note': note,
    };

    if (image != null) {
      final imageFile = File(image);
      final fileName = imageFile.path.split('/').last;
      form['image'] = MultipartFile(
        imageFile,
        filename: fileName,
      );
    }

    final data = FormData(form);

    Response response = await post(
      '/maintenance/create',
      data,
      headers: {'Authorization': 'Bearer $token'},
    );
    return createResponse(response);
  }



  Future<Response> submitMaintenance(int id, String token) async {
    Response response = await post(
      '/maintenance/assign',
      { 'id': id },
      headers: {'Authorization': 'Bearer $token'},
    );
    return createResponse(response);
  }

  Future<Response> submitMaintenanceApproval(id, pathPicture, token) async {

    final imageFile = File(pathPicture);
    final fileName = imageFile.path.split('/').last;

    final data = FormData({
      'id' : id,
      'approved_picture' :  MultipartFile(
        imageFile,
        filename: fileName,
      )
    });

    Response response = await post(
      '/maintenance/approve',
      data,
      headers: {'Authorization': 'Bearer $token'},
    );
    return createResponse(response);
  }
}
