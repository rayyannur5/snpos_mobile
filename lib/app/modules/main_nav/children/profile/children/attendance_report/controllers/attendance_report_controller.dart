import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snpos/app/modules/main_nav/children/profile/providers/profile_provider.dart';

class AttendanceReportController extends GetxController {
  final ProfileProvider provider;
  AttendanceReportController(this.provider);

  Rxn<DateTimeRange> dateRange = Rxn<DateTimeRange>();
  var isLoading = false.obs;
  var attendances = [].obs;

  var headerLoading = false.obs;
  var summary = {}.obs;

  @override
  void onInit() {
    super.onInit();

    dateRange.value = DateTimeRange(
      start: DateTime.now().subtract(Duration(days: 7)),
      end: DateTime.now(),
    );

    fetchAttendances();
    summaryAttendances();
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
      fetchAttendances();
      summaryAttendances();
    }
  }

  Future<void> fetchAttendances() async {
    isLoading.value = true;

    var response = await provider.fetchAttendances(dateRange.value!.start, dateRange.value!.end);

    if(response.statusCode == 200) {
      attendances.value = response.body['data'];
    } else {
      Get.snackbar('Error fetch transaction', response.body['message']);
    }

    isLoading.value = false;
  }

  Future<void> summaryAttendances() async {
    headerLoading.value = true;

    var response = await provider.summaryAttendances(dateRange.value!.start, dateRange.value!.end);

    if(response.statusCode == 200) {
      summary.value = response.body['data'];
    } else {
      Get.snackbar('Error fetch transaction', response.body['message']);
    }

    headerLoading.value = false;
  }

  Future<void> refreshPage() async {
    fetchAttendances();
    summaryAttendances();
  }

}
