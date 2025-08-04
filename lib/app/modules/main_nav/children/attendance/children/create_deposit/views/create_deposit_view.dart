import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:snpos/app/utils/currency_formatter.dart';

import '../controllers/create_deposit_controller.dart';

class CreateDepositView extends GetView<CreateDepositController> {
  const CreateDepositView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Buat Laporan', style: Get.textTheme.headlineLarge), toolbarHeight: 80),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(padding: EdgeInsets.all(20), width: Get.width, child: Obx(
        () {
          if(controller.buttonLoading.value) {
            return FilledButton(onPressed: null, child: SizedBox(height: 30, width: 30, child: CircularProgressIndicator()));
          } else {
            return FilledButton(onPressed: () => controller.deposit(), child: Text('Setorkan'));
          }
        }
      )),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchTransactionNotDepositYet(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                SizedBox(
                  width: Get.width,
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
                      ...controller.response['items']
                          .map<DataRow>(
                            (item) => DataRow(
                              cells: [
                                DataCell(Text(item['productName'], style: TextStyle(fontSize: 12))),
                                DataCell(Text(item['qty'].toString(), style: TextStyle(fontSize: 12))),
                                DataCell(Text(CurrencyFormatter.toRupiah(item['price']), style: TextStyle(fontSize: 12))),
                                DataCell(Text(CurrencyFormatter.toRupiah(item['totalAmount']), style: TextStyle(fontSize: 12))),
                              ],
                            ),
                          )
                          .toList(),
                      DataRow(
                        cells: [
                          DataCell(Text('Total', style: TextStyle(fontSize: 12))),
                          DataCell(SizedBox()),
                          DataCell(SizedBox()),
                          DataCell(Text(CurrencyFormatter.toRupiah(controller.response['totalAmount']), style: TextStyle(fontSize: 12))),
                        ],
                      ),
                    ],
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
