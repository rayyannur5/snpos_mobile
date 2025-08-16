import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:snpos/app/modules/main_nav/children/profile/providers/profile_provider.dart';
import 'package:snpos/app/widgets/no_internet_widget.dart';

class OvertimeApplicationController extends GetxController {

  final ProfileProvider provider;
  OvertimeApplicationController(this.provider);

  var status = {}.obs;

  var operators = [].obs;
  var selectedOperator = RxnInt();

  var selectedDate = Rxn<DateTime>();

  var shifts = [].obs;
  var selectedShift = RxnInt();

  var startTime = TimeOfDay(hour: 8, minute: 0).obs;
  var endTime = TimeOfDay(hour: 17, minute: 0).obs;

  var noteController = TextEditingController();

  var error = false.obs;
  var messageError = ''.obs;

  var loadingButton = false.obs;

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();

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
    status.value = {
      'loading': true,
      'error': false,
      'message': '',
    };
    final response = await provider.getOperatorsAndShift(token);
    if (response.statusCode == 200) {
      status.value = {
        'loading': false,
        'error': false,
        'message': '',
      };
      // Asumsikan response body list of operator names
      operators.value = response.body['data']['users'];
      shifts.value = response.body['data']['shifts'];
    } else {
      status.value = {
        'loading': false,
        'error': true,
        'message': response.body['message'],
      };
    }
  }

  void pickStartTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: startTime.value,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      startTime.value = picked;
    }
  }

  void pickEndTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: endTime.value,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      endTime.value = picked;
    }
  }

  String formatTime24(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void onShiftChanged(Map<String, dynamic> shift) {
    selectedShift.value = shift['id'];
    final startParts = (shift['start_time'] as String).split(':');
    final endParts = (shift['end_time'] as String).split(':');

    startTime.value = TimeOfDay(
      hour: int.parse(startParts[0]),
      minute: int.parse(startParts[1]),
    );

    endTime.value = TimeOfDay(
      hour: int.parse(endParts[0]),
      minute: int.parse(endParts[1]),
    );
  }


  Future<void> submitOvertime() async {
    if (selectedOperator.value == null ||
        selectedDate.value == null ||
        selectedShift.value == null ) {
      Get.snackbar('Error', 'Lengkapi semua form terlebih dahulu', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    loadingButton.value = true;

    final data = {
      'operator': selectedOperator.value,
      'shift': selectedShift.value,
      'date': selectedDate.value!.toIso8601String(),
      'start_time': '${twoDigits(startTime.value.hour)}:${twoDigits(startTime.value.minute)}',
      'end_time': '${twoDigits(endTime.value.hour)}:${twoDigits(endTime.value.minute)}',
      'remarks': noteController.text,
    };

    String token = box.read('token');

    Response response = await provider.submitOvertime(data, token);

    loadingButton.value = false;

    if(response.statusCode == 200) {
      Get.back();
      await Future.delayed(Duration(milliseconds: 500));
      Get.snackbar('Berhasil Mengajukan Lembur', 'Lembur Anda telah berhasil dikirim', backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      Get.dialog(Dialog(
        child: Container(
          width: Get.width,
          height: Get.height/2,
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: NoInternetWidget(onClickRefresh: () {
              Get.back();
              submitOvertime();
            }, errorMessage: response.body['message']),
          ),
        ),
      ));
    }
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');
}
