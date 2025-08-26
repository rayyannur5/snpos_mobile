import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:snpos/app/config/constants.dart';
import 'package:snpos/app/modules/leave_request/providers/leave_request_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class LeaveRequestController extends GetxController {

  final LeaveRequestProvider provider;
  LeaveRequestController(this.provider);

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
      var temps = response.body['data'];
      for(var t in temps) {
        t['isExpanded'] = false;
      }
      requests.value = temps;
    }
    else {
      state.value = {
        'loading': false,
        'error': true,
        'message': response.body['message'],
      };
    }
  }

  void dialogPicture(gambar) {
    Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.zero, // fullscreen
        backgroundColor: Colors.black,
        child: GestureDetector(
          onTap: () => Get.back(), // klik di gambar untuk close
          child: InteractiveViewer(
            child: Image.network(
              "${AppConstants.storageUrl}/$gambar",
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  void dialogPDF(pdf) {
    Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.zero, // fullscreen
        backgroundColor: Colors.black,
        child: GestureDetector(
          onTap: () => Get.back(), // klik di gambar untuk close
          child: SfPdfViewer.network("${AppConstants.storageUrl}/$pdf"),
        ),
      ),
    );
  }
}
