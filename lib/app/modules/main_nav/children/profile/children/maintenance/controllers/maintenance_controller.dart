import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:snpos/app/config/constants.dart';
import 'package:snpos/app/modules/main_nav/children/profile/providers/profile_provider.dart';

class MaintenanceController extends GetxController {
  final ProfileProvider provider;
  MaintenanceController(this.provider);

  var state = {}.obs;
  var jobs = [].obs;

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();

    fetchMaintenanceJobs();

  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> fetchMaintenanceJobs() async {
    String token = box.read('token');
    state.value = {
      'loading': true,
      'error': false,
      'message': '',
    };
    final response = await provider.getMaintenanceJobs(token);
    if (response.statusCode == 200) {
      state.value = {
        'loading': false,
        'error': false,
        'message': '',
      };
      // Asumsikan response body list of operator names
      var temps = response.body['data'];
      for(var t in temps) {
        t['isExpanded'] = false;
      }
      jobs.value = temps;
    }
    else {
      state.value = {
        'loading': false,
        'error': true,
        'message': response.body['message'],
      };
    }
  }

  void dialogJob(data) {
    Get.dialog(
        AlertDialog(
          title: Text('Kerjakan'),
          content: Text('Apakah Anda mengerjakan perbaikan ${data['item_name']}'),
          actions: [
            TextButton(onPressed: () => Get.back(), child: Text('Tidak', style: TextStyle(color: Colors.red),)),
            FilledButton(onPressed: () => submitMaintenance(data['id']), child: Text('Kerjakan')),
          ],
        )
    );
  }

  Future<void> submitMaintenance(id) async {
    String token = box.read('token');
    Get.dialog(Center(child: CircularProgressIndicator(color: Colors.white)), barrierDismissible: false);
    final response = await provider.submitMaintenance(id, token);
    if (response.statusCode == 200) {
      Get.back();
      Get.back();
      await Future.delayed(Duration(milliseconds: 500));
      Get.snackbar('Berhasil', 'Perbaikan berhasil', backgroundColor: Colors.green, colorText: Colors.white);
      fetchMaintenanceJobs();
    } else {
      Get.back();
      Get.snackbar('Gagal', response.body['message'], backgroundColor: Colors.red, colorText: Colors.white);
    }

  }

  void dialogPicture(data) {
    Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.zero, // fullscreen
        backgroundColor: Colors.black,
        child: GestureDetector(
          onTap: () => Get.back(), // klik di gambar untuk close
          child: InteractiveViewer(
            child: Image.network(
              "${AppConstants.storageUrl}/${data['request_picture']}",
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

}
