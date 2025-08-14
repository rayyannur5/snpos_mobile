import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:snpos/app/modules/main_nav/children/profile/providers/profile_provider.dart';

class DepositReportController extends GetxController {
  final ProfileProvider provider;
  DepositReportController(this.provider);

  Rxn<DateTimeRange> dateRange = Rxn<DateTimeRange>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var deposits = [].obs;

  var headerLoading = false.obs;
  var summary = {}.obs;

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();

    dateRange.value = DateTimeRange(
      start: DateTime.now().subtract(Duration(days: 7)),
      end: DateTime.now(),
    );

    fetchDeposits();
    summaryDeposits();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void pickDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: dateRange.value,
    );

    if (picked != null) {
      dateRange.value = picked;
      fetchDeposits();
      summaryDeposits();
    }
  }

  Future<void> fetchDeposits() async {
    isLoading.value = true;
    errorMessage.value = '';
    String token = box.read('token');
    var response = await provider.fetchDeposits(dateRange.value!.start, dateRange.value!.end, token);

    if(response.statusCode == 200) {
      deposits.value = response.body['data'];
    } else {
      errorMessage.value = response.body['message'];
    }

    isLoading.value = false;
  }

  Future<void> summaryDeposits() async {
    headerLoading.value = true;
    String token = box.read('token');
    var response = await provider.summaryDeposits(dateRange.value!.start, dateRange.value!.end, token);

    if(response.statusCode == 200) {
      summary.value = response.body['data'];
    } else {
      Get.snackbar('Error fetch data', response.body['message'], backgroundColor: Colors.red,colorText: Colors.white);
    }

    headerLoading.value = false;
  }

  Future<void> refreshPage() async  {
    fetchDeposits();
    summaryDeposits();
  }
}
