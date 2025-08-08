import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snpos/app/modules/main_nav/children/profile/providers/profile_provider.dart';

class SalesReportController extends GetxController {

  final ProfileProvider provider;
  SalesReportController(this.provider);

  Rxn<DateTimeRange> dateRange = Rxn<DateTimeRange>();

  var isLoading = false.obs;
  var transactions = [].obs;

  var headerLoading = false.obs;
  var summary = {}.obs;

  @override
  void onInit() {
    super.onInit();
    dateRange.value = DateTimeRange(
      start: DateTime.now().subtract(Duration(days: 7)),
      end: DateTime.now(),
    );

    fetchSalesReport();
    summarySalesReport();
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
      fetchSalesReport();
      summarySalesReport();
    }
  }

  void fetchSalesReport() async {
    isLoading.value = true;

    var response = await provider.fetchSalesReport(dateRange.value!.start, dateRange.value!.end);

    if(response.statusCode == 200) {
      transactions.value = response.body['data'];
    } else {
      Get.snackbar('Error fetch transaction', response.body['message']);
    }

    isLoading.value = false;
  }

  void summarySalesReport() async {
    headerLoading.value = true;

    var response = await provider.summarySalesReport(dateRange.value!.start, dateRange.value!.end);

    if(response.statusCode == 200) {
      summary.value = response.body['data'];
    } else {
      Get.snackbar('Error fetch transaction', response.body['message']);
    }

    headerLoading.value = false;
  }

  Future<void> refreshPage() async {
    fetchSalesReport();
    summarySalesReport();
  }

}
