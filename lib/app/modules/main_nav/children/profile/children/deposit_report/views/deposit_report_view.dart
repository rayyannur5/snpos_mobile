import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:snpos/app/utils/currency_formatter.dart';

import '../controllers/deposit_report_controller.dart';

class DepositReportView extends GetView<DepositReportController> {
  const DepositReportView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: ClipRRect(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
          child: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Laporan Setoran', style: Get.textTheme.headlineLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text('Tabungan', style: Get.textTheme.bodyMedium?.copyWith(color: Colors.white),),
                Obx(() {
                  if(controller.headerLoading.value) {
                    return Shimmer(
                      child: Text(CurrencyFormatter.toRupiah(600000), style: Get.textTheme.bodyMedium?.copyWith(color: Colors.transparent))
                    );
                  } else {
                    return Text(CurrencyFormatter.toRupiah(int.parse(controller.summary['tabungan'] ?? '0')), style: Get.textTheme.bodyMedium?.copyWith(color: Colors.white),);
                  }
                })


              ],
            ),
            toolbarHeight: 150,
            backgroundColor: Get.theme.primaryColor,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: RefreshIndicator(
          onRefresh: controller.refreshPage,
          child: ListView(
            children: [
              GestureDetector(
                onTap: () => controller.pickDateRange(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color(0xffD9D9D9),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(DateFormat('dd/MM/yyyy').format(controller.dateRange.value!.start)),
                          const SizedBox(width: 10),
                          Icon(Icons.calendar_month)
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color(0xffD9D9D9),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(DateFormat('dd/MM/yyyy').format(controller.dateRange.value!.start)),
                          const SizedBox(width: 10),
                          Icon(Icons.calendar_month)
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Obx(() {
                if (controller.isLoading.value) {
                  return SizedBox(height: Get.height/2, child: Center(child: CircularProgressIndicator()));
                } else {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: controller.deposits.map((e) {
                      return widgetSalesReport(
                        date: DateTime.parse(e['date']),
                        outlet: e['outlet'],
                        omset: e['omset'],
                      );
                    }).toList(),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Container widgetSalesReport({required String outlet, required DateTime date, required int omset}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: () {},
          child: ListTile(
            title: Text(outlet, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(DateFormat('dd/MM/yyyy | HH:mm').format(date)),
            trailing: FilledButton(onPressed: () {}, child: Text(CurrencyFormatter.toRupiah(omset))),
          ),
        ),
      ),
    );
  }

}
