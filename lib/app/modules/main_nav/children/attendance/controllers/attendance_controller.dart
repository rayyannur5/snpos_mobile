import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:snpos/app/enums/absen_status.dart';
import 'package:snpos/app/modules/main_nav/children/attendance/providers/attendance_provider.dart';

class AttendanceController extends GetxController {
  final AttendanceProvider provider;
  AttendanceController(this.provider);

  var absenStatus = AbsenStatus.IsNotAbsen.obs;
  var isLoading = false.obs;

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();

    var user = box.read('user');

    if (user['is_absen'] == 'Y') {
      absenStatus.value = AbsenStatus.IsAbsen;
    } else if (user['is_absen'] == 'N') {
      absenStatus.value = AbsenStatus.IsNotAbsen;
    } else if (user['is_absen'] == 'X') {
      absenStatus.value = AbsenStatus.AfterAbsen;
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }



  Future<void> refreshPage() async {
    isLoading.value = true;
    var response = await provider.updateUserData(box.read('token'));
    var user = response.body['data'];
    box.write('user', user);

    if (user['is_absen'] == 'Y') {
      absenStatus.value = AbsenStatus.IsAbsen;
    } else if (user['is_absen'] == 'N') {
      absenStatus.value = AbsenStatus.IsNotAbsen;
    } else if (user['is_absen'] == 'X') {
      absenStatus.value = AbsenStatus.AfterAbsen;
    }
    isLoading.value = false;
  }

}
