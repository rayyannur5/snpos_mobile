import 'package:get/get.dart';
import 'package:snpos/app/enums/absen_status.dart';
import 'package:snpos/app/modules/main_nav/children/attendance/providers/attendance_provider.dart';

class AttendanceController extends GetxController {
  final AttendanceProvider provider;
  AttendanceController(this.provider);

  var absenStatus = AbsenStatus.IsNotAbsen.obs;
  var isLoading = true.obs;


  @override
  void onInit() {
    super.onInit();
    fetchAbsenStatus();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> fetchAbsenStatus() async {
    try {
      isLoading.value = true;

      final response = await provider.getAbsenStatus();
      if (response.statusCode == 200) {
        if (response.body['data'] == 'Y') {
          absenStatus.value = AbsenStatus.IsAbsen;
        } else if (response.body['data'] == 'N') {
          absenStatus.value = AbsenStatus.IsNotAbsen;
        } else if (response.body['data'] == 'X') {
          absenStatus.value = AbsenStatus.AfterAbsen;
        } else {
          absenStatus.value = AbsenStatus.IsNotAbsen;
        }
      } else {
        Get.snackbar('Error', 'Gagal ambil data');
        isLoading.value = false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan');
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }

}
