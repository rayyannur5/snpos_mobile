import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:snpos/app/modules/maintenance/providers/maintenance_provider.dart';
import 'package:snpos/app/utils/delete_photo.dart';

class MaintenanceRequestController extends GetxController {
  final MaintenanceProvider provider;
  MaintenanceRequestController(this.provider);

  var state = {}.obs;
  var items = [].obs;
  var selectedItem = RxnInt();
  var outlets = [].obs;
  var selectedOutlet = RxnInt();
  var loadingButton = false.obs;
  var image = RxnString();

  TextEditingController noteController = TextEditingController();

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();

    var user = box.read('user');
    selectedOutlet.value = user['outlet_id'];
    fetchMaintenanceRequest();

  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> fetchMaintenanceRequest() async {
    String token = box.read('token');
    state.value = {
      'loading': true,
      'error': false,
      'message': '',
    };
    final response = await provider.getMaintenanceRequest(token);
    if (response.statusCode == 200) {
      state.value = {
        'loading': false,
        'error': false,
        'message': '',
      };
      // Asumsikan response body list of operator names
      items.value = response.body['data']['items'];
      outlets.value = response.body['data']['outlets'];
    }
    else {
      state.value = {
        'loading': false,
        'error': true,
        'message': response.body['message'],
      };
    }
  }

  Future<void> submitMaintenanceRequest() async {

    if(selectedItem.value == null || selectedOutlet.value == null || noteController.text.isEmpty || image.value == null) {
      Get.snackbar('Error', 'Semua field harus diisi', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    loadingButton.value = true;
    String token = box.read('token');
    final response = await provider.submitMaintenanceRequest(token, selectedItem.value!, selectedOutlet.value!, noteController.text, image.value);
    if (response.statusCode == 200) {
      loadingButton.value = false;
      await DeletePhoto.deletePhoto(image.value!);
      Get.back();
    }
    else {
      loadingButton.value = false;
      Get.snackbar('Error', response.body['message'], backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}