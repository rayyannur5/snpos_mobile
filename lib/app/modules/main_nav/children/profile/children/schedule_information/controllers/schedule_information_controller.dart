import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snpos/app/modules/main_nav/children/profile/providers/profile_provider.dart';

class ScheduleInformationController extends GetxController {
  final ProfileProvider provider;
  ScheduleInformationController(this.provider);

  Rxn<DateTimeRange> dateRange = Rxn<DateTimeRange>();

  var isLoading = false.obs;
  var schedules = [].obs;

  @override
  void onInit() {
    super.onInit();

    dateRange.value = DateTimeRange(
      start: DateTime.now().subtract(Duration(days: 7)),
      end: DateTime.now(),
    );

    fetchSchedule();
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
      fetchSchedule();
    }
  }

  Future<void> fetchSchedule() async {
    isLoading.value = true;
    var response = await provider.fetchSchedule(dateRange.value!.start, dateRange.value!.end);
    if(response.statusCode == 200) {
      schedules.value = response.body['data'];
    } else {
      Get.snackbar('Error fetch schedule', response.body['message']);
    }
    isLoading.value = false;
  }
}
