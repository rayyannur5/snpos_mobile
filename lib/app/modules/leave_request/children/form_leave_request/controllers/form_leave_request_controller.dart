import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:snpos/app/modules/leave_request/providers/leave_request_provider.dart';

class FormLeaveRequestController extends GetxController {
  final LeaveRequestProvider provider;
  FormLeaveRequestController(this.provider);

  var state = {}.obs;
  var operator = [].obs;
  var categories = [].obs;
  var selectedOperator = RxnInt();
  var selectedCategory = RxnInt();
  var loadingButton = false.obs;
  var startDate = Rxn<DateTime>();
  var endDate = Rxn<DateTime>();
  var attachedFile = Rxn<File>();

  final ImagePicker _picker = ImagePicker();

  final box = GetStorage();

  final dateFormat = DateFormat('yyyy-MM-dd');

  // Untuk TextField binding
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController remarksController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    var user = box.read('user');
    selectedOperator.value = user['id'];

    fetchOperators();

  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> fetchOperators() async {
    String token = box.read('token');
    state.value = {
      'loading': true,
      'error': false,
      'message': '',
    };
    final response = await provider.getOperators(token);
    if (response.statusCode == 200) {
      state.value = {
        'loading': false,
        'error': false,
        'message': '',
      };
      // Asumsikan response body list of operator names
      operator.value = response.body['data']['operator'];
      categories.value = response.body['data']['categories'];
    }
    else {
      state.value = {
        'loading': false,
        'error': true,
        'message': response.body['message'],
      };
    }
  }

  Future<void> pickStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      startDate.value = picked;
      startDateController.text = dateFormat.format(picked);
    }
  }

  Future<void> pickEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: endDate.value ?? (startDate.value ?? DateTime.now()),
      firstDate: startDate.value ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      endDate.value = picked;
      endDateController.text = dateFormat.format(picked);
    }
  }

  Future<void> pickFromCamera() async {
    final picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      attachedFile.value = File(picked.path);
    }
  }

  Future<void> pickFromGallery() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      attachedFile.value = File(picked.path);
    }
  }

  Future<void> pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      attachedFile.value = File(result.files.single.path!);
    }
  }

  Future<void> submitLeave() async {
    if (selectedOperator.value == null) {
      Get.snackbar("Error", "Pilih operator terlebih dahulu", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (selectedCategory.value == null) {
      Get.snackbar("Error", "Pilih kategori terlebih dahulu", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (startDate.value == null || endDate.value == null) {
      Get.snackbar("Error", "Isi tanggal mulai dan selesai", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (endDate.value!.isBefore(startDate.value!)) {
      Get.snackbar("Error", "Tanggal selesai tidak boleh sebelum tanggal mulai", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (remarksController.text.isEmpty) {
      Get.snackbar("Error", "Isi Catatan", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    loadingButton.value = true; // ✅ mulai loading

    String token = box.read('token');

    try {
      final res = await provider.submitLeave(
        operatorId: selectedOperator.value!,
        categoryId: selectedCategory.value!,
        startDate: startDate.value!,
        endDate: endDate.value!,
        remarks: remarksController.text,
        file: attachedFile.value, token: token,
      );

      if (res.isOk) {
        Get.back();
        await Future.delayed(Duration(milliseconds: 200));
        Get.snackbar("Success", "Data berhasil dikirim", backgroundColor: Colors.green, colorText: Colors.white);

        // reset form
        remarksController.clear();
        attachedFile.value = null;
        startDate.value = null;
        endDate.value = null;
        selectedOperator.value = null;
        selectedCategory.value = null;
      } else {
        Get.snackbar("Error", res.body['message'], backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      loadingButton.value = false; // ✅ stop loading
    }
  }

}
