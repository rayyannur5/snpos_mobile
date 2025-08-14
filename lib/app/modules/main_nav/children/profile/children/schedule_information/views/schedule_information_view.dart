import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:snpos/app/widgets/no_internet_widget.dart';

import '../controllers/schedule_information_controller.dart';

class ScheduleInformationView extends GetView<ScheduleInformationController> {
  const ScheduleInformationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: ClipRRect(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
          child: AppBar(title: Text('Informasi Jadwal'), backgroundColor: Get.theme.primaryColor, foregroundColor: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: RefreshIndicator(
          onRefresh: controller.fetchSchedule,
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
                  return SizedBox(height: Get.height / 2, child: Center(child: CircularProgressIndicator()));
                }
                else if(controller.errorMessage.value != '') {
                  return NoInternetWidget(onClickRefresh: () => controller.fetchSchedule(), errorMessage: controller.errorMessage.value);
                }
                else {
                  List<dynamic> dataList = controller.schedules;
                  List<String> columnKeys = [];

                  if (dataList.isNotEmpty && dataList.first is Map<String, dynamic>) {
                    columnKeys = (dataList.first as Map<String, dynamic>).keys.toList();
                  }

                  if(columnKeys.isEmpty) {
                    return SizedBox(height: Get.height/2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/no_data.png'),
                        Text('Tidak ada data yang ditemukan', style: Get.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),)
                      ],
                    ),);
                  }

                  return DataTable(
                    columnSpacing: 10,
                    dataRowMinHeight: 30,
                    dataRowMaxHeight: 40,
                    headingRowHeight: 30,
                    columns: [
                      DataColumn(label: Text('Tanggal')),
                      DataColumn(label: Text('Shift')),
                      DataColumn(label: Text('Outlet')),
                      DataColumn(label: Text('Status'))
                    ],
                    rows:
                        dataList.map((item) {
                          final row = item as Map<String, dynamic>;
                          return DataRow(
                            cells: [
                              DataCell(Text(DateFormat('dd/MM/yyyy').format(DateTime.parse(row['date'])))),
                              DataCell(Text(row['shift'])),
                              DataCell(Text(row['outlet'])),
                              DataCell(Center(child: Text(row['status'] == 1 ? '🟢' : row['status'] == 2 ? '🔴' : '')), ),
                            ]
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
}
