import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:snpos/app/modules/item_requests/providers/item_request_provider.dart';

class FormItemRequestController extends GetxController {
  final ItemRequestProvider provider;
  FormItemRequestController(this.provider);
  var state = {}.obs;
  var items = [].obs;
  var outlets = [].obs;
  var selectedItem = RxnInt();
  var selectedOutlet = RxnInt();
  var loadingButton = false.obs;
  final TextEditingController noteController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final box = GetStorage();
  late Map user;

  @override
  void onInit() {
    super.onInit();

    user = box.read('user');
    selectedOutlet.value = user['outlet_id'];

    fetchItemsOutlets();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> fetchItemsOutlets() async {
    String token = box.read('token');
    state.value = {
      'loading': true,
      'error': false,
      'message': '',
    };
    final response = await provider.getItemsOutlets(token);
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

  Future<void> submitItemRequest() async {
    String token = box.read('token');
    loadingButton.value = true;
    final response = await provider.submitItemRequest(token, selectedItem.value!, selectedOutlet.value!, qtyController.text, noteController.text);
    if (response.statusCode == 200) {
      loadingButton.value = false;
      Get.back();
    }
    else {
      loadingButton.value = false;
      Get.snackbar('Error', response.body['message'], backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

}
