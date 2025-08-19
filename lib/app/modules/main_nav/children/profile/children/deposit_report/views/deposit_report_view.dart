import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:snpos/app/utils/currency_formatter.dart';
import 'package:snpos/app/widgets/no_internet_widget.dart';

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
                Obx(() {
                  if(controller.headerLoading.value) {
                    return Shimmer(
                      child: DataTable(
                        dataRowMaxHeight: 30,
                        dataRowMinHeight: 30,
                        headingRowHeight: 30,
                        horizontalMargin: 0,
                        columns: const <DataColumn>[
                          DataColumn(label: Text('Tepat Waktu', style: TextStyle(color: Colors.transparent, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text(':', style: TextStyle(color: Colors.transparent, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('3', style: TextStyle(color: Colors.transparent, fontWeight: FontWeight.bold))),
                        ],
                        rows: const <DataRow>[
                          DataRow(
                            cells: <DataCell>[
                              DataCell(Text('Terlambat', style: TextStyle(color: Colors.transparent, fontWeight: FontWeight.bold))),
                              DataCell(Text(':', style: TextStyle(color: Colors.transparent, fontWeight: FontWeight.bold))),
                              DataCell(Text('3423', style: TextStyle(color: Colors.transparent, fontWeight: FontWeight.bold))),
                            ],
                          ),
                          DataRow(
                            cells: <DataCell>[
                              DataCell(Text('Terlambat', style: TextStyle(color: Colors.transparent, fontWeight: FontWeight.bold))),
                              DataCell(Text(':', style: TextStyle(color: Colors.transparent, fontWeight: FontWeight.bold))),
                              DataCell(Text('3423', style: TextStyle(color: Colors.transparent, fontWeight: FontWeight.bold))),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                  else if(controller.errorMessage.value != '') {
                    return Text('No Internet');
                  }
                  else {
                    return DataTableTheme(
                      data: DataTableThemeData(
                        headingRowHeight: 0, // hilangkan heading
                        dataRowColor: MaterialStateProperty.all(Colors.transparent),
                        headingRowColor: MaterialStateProperty.all(Colors.transparent),
                        dividerThickness: 0,
                        decoration: BoxDecoration(), // hilangkan background table
                      ),
                      child: DataTable(
                        dataRowMaxHeight: 30,
                        dataRowMinHeight: 30,
                        headingRowHeight: 30,
                        columnSpacing: 10,
                        horizontalMargin: 0,
                        columns: <DataColumn>[
                          DataColumn(label: Text('Tabungan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text(':', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text(controller.summary['tabungan'] == null ? '0' : controller.summary['tabungan'].toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        ],
                        rows: <DataRow>[
                          DataRow(
                            cells: <DataCell>[
                              DataCell(Text('Sudah Disetorkan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                              DataCell(Text(':', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                              DataCell(Text(controller.summary['deposit'] == null ? '-' : controller.summary['deposit'].toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                            ],
                          ),
                          DataRow(
                            cells: <DataCell>[
                              DataCell(Text('Sudah Diverifikasi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                              DataCell(Text(':', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                              DataCell(Text(controller.summary['verified'] == null ? '-' : controller.summary['verified'].toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                            ],
                          ),
                        ],
                      ),
                    );
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
                }
                else if(controller.errorMessage.value != '') {
                  return NoInternetWidget(onClickRefresh: () => controller.refreshPage(), errorMessage: controller.errorMessage.value,);
                }
                else {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: controller.deposits.map((e) {
                      return widgetSalesReport(
                        date: DateTime.parse(e['date']),
                        outlet: e['outlet'],
                        omset: e['omset'],
                        verified: e['verified'] == 1 ? true : false
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

  Container widgetSalesReport({required String outlet, required DateTime date, required int omset, required bool verified}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: () {},
          child: ListTile(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(outlet, style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 5),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 1, horizontal: 2),
                  decoration: BoxDecoration(
                    color: verified ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(4)
                  ),
                  child: Text(verified ? 'Terverifikasi' : 'Belum Verifikasi', style: Get.textTheme.labelSmall!.copyWith(color: Colors.white),),
                )
              ],
            ),
            subtitle: Text(DateFormat('dd/MM/yyyy | HH:mm').format(date)),
            trailing: FilledButton(onPressed: () {}, child: Text(CurrencyFormatter.toRupiah(omset))),
          ),
        ),
      ),
    );
  }

}
