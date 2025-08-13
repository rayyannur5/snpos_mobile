import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:snpos/app/utils/currency_formatter.dart';

import '../controllers/detail_absensi_controller.dart';

class DetailAbsensiView extends GetView<DetailAbsensiController> {
  const DetailAbsensiView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Info Absensi', style: Get.textTheme.headlineLarge), toolbarHeight: 80),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () => controller.detailAttendance(controller.id),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                SizedBox(
                  width: Get.width,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      dataRowMinHeight: 12, // default biasanya 56
                      dataRowMaxHeight: 32,
                      headingRowHeight: 32,
                      columnSpacing: 12, // jarak antar kolom
                      columns: const [
                        DataColumn(label: Text('Barang', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Harga', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Total Harga', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: [
                        ...controller.response['transactions'].map<DataRow>((item) {
                          return DataRow(
                            cells: [
                              DataCell(Text(item['product_name'], style: TextStyle(fontSize: 12))),
                              DataCell(Text(item['qty'], style: TextStyle(fontSize: 12))),
                              DataCell(Text(CurrencyFormatter.toRupiah(item['price']), style: TextStyle(fontSize: 12))),
                              DataCell(Text(CurrencyFormatter.toRupiah(int.parse(item['total_amount'])), style: TextStyle(fontSize: 12))),
                            ],
                          );
                        }).toList(),
                        DataRow(
                          cells: [
                            DataCell(Text('Total', style: TextStyle(fontSize: 12))),
                            DataCell(SizedBox()),
                            DataCell(SizedBox()),
                            DataCell(Text(CurrencyFormatter.toRupiah(int.parse(controller.response['total_amount'] ?? '0')), style: TextStyle(fontSize: 12))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
