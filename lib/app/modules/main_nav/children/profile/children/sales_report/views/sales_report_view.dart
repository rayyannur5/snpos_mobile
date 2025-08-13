import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:snpos/app/utils/currency_formatter.dart';

import '../controllers/sales_report_controller.dart';

class SalesReportView extends GetView<SalesReportController> {
  const SalesReportView({super.key});
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
                Text('Laporan Penjualan', style: Get.textTheme.headlineLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
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
                            DataColumn(label: Text('Banyak Penjualan', style: TextStyle(color: Colors.transparent, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text(':', style: TextStyle(color: Colors.transparent, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('3', style: TextStyle(color: Colors.transparent, fontWeight: FontWeight.bold))),
                          ],
                          rows: const <DataRow>[
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('Omset', style: TextStyle(color: Colors.transparent, fontWeight: FontWeight.bold))),
                                DataCell(Text(':', style: TextStyle(color: Colors.transparent, fontWeight: FontWeight.bold))),
                                DataCell(Text('3', style: TextStyle(color: Colors.transparent, fontWeight: FontWeight.bold))),
                              ],
                            ),
                          ],
                        ),
                      );
                  } else {
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
                          DataColumn(label: Text('Banyak Penjualan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text(':', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('${controller.summary['total'].toString()} Transaksi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        ],
                        rows: <DataRow>[
                          DataRow(
                            cells: <DataCell>[
                              DataCell(Text('Omset', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                              DataCell(Text(':', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                              DataCell(Text(CurrencyFormatter.toRupiah(int.parse(controller.summary['omset'] ?? '0')), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
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
                      decoration: BoxDecoration(color: Color(0xffD9D9D9), borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Obx(() {
                            return Text(DateFormat('dd/MM/yyyy').format(controller.dateRange.value!.start));
                          }),
                          const SizedBox(width: 10),
                          Icon(Icons.calendar_month),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Color(0xffD9D9D9), borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Obx(() {
                            return Text(DateFormat('dd/MM/yyyy').format(controller.dateRange.value!.end));
                          }),
                          const SizedBox(width: 10),
                          Icon(Icons.calendar_month),
                        ],
                      ),
                    ),
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
                    children: controller.transactions.map((transaction) {
                      return widgetSalesReport(
                        area: transaction['outlet'],
                        date: DateTime.parse(transaction['date']),
                        price: transaction['sell'],
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

  Container widgetSalesReport({required area, required DateTime date, required price}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: () {},
          child: ListTile(
            title: Text(area, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(DateFormat('dd/MM/yyyy | HH:mm').format(date)),
            trailing: FilledButton(onPressed: () {}, child: Text(CurrencyFormatter.toRupiah(price))),
          ),
        ),
      ),
    );
  }
}
