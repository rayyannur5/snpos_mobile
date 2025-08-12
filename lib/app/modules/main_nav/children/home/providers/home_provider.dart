import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:snpos/app/data/providers/base_api_provider.dart';

class HomeProvider extends BaseApiProvider {

  Future<Response> updateUserData(String token) => get('/attendance', headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'});

  Future<Response> getListProducts(String token) {
    return get('/transaction/products', headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'});
  }

  Future<Response> sendListProducts(transaction, items, String token) async {

    final imageFile = transaction['path_picture'] != '' && transaction['path_picture'] != null ? File(transaction['path_picture']) : null; // ambil file dari path
    final fileName = imageFile != null ? imageFile.path.split('/').last : ''; // nama file

    final form = FormData({
      'transaction': jsonEncode(transaction),
      'items': jsonEncode(items),
      'photo': fileName == '' ? null : MultipartFile(
        imageFile,
        filename: fileName,
      ),
    });

    return post('/transaction/create', form, headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'});
  }

  Future<Response> getPaymentMethod(String token) async {
    return get('/transaction/payments', headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'});
  }

}
