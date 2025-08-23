import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:snpos/app/modules/item_requests/providers/item_request_provider.dart';

class ItemRequestsController extends GetxController {
  final ItemRequestProvider provider;
  ItemRequestsController(this.provider);

  var state = {}.obs;
  var requests = [].obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchRequests();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> fetchRequests() async {
    String token = box.read('token');
    state.value = {
      'loading': true,
      'error': false,
      'message': '',
    };
    final response = await provider.getRequests(token);
    if (response.statusCode == 200) {
      state.value = {
        'loading': false,
        'error': false,
        'message': '',
      };
      requests.value = response.body['data'];
    }
    else {
      state.value = {
        'loading': false,
        'error': true,
        'message': response.body['message'],
      };
    }
  }

  void dialogAccept(data) {
    Get.dialog(AlertDialog(
      title: Text('Terima'),
      content: Text('Apakah anda yakin?'),
      actions: [
        TextButton(onPressed: () => Get.back(), child: Text('Tidak')),
        TextButton(onPressed: () => acceptRequest(data['id']), child: Text('Ya')),
      ],
    ));
  }

  Future<void> acceptRequest(id) async {
    String token = box.read('token');
    Get.dialog(Center(child: CircularProgressIndicator(color: Colors.white,),));
    final response = await provider.acceptRequest(token,id);
    if (response.statusCode == 200) {
      Get.back();
      Get.back();
      await Future.delayed(Duration(milliseconds: 300));
      Get.snackbar('Berhasil', "Berhasil menerima barang", backgroundColor: Colors.green, colorText: Colors.white);
      fetchRequests();
    } else {
      Get.back();
      await Future.delayed(Duration(milliseconds: 300));
      Get.snackbar('Error', response.body['message'], backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

}
