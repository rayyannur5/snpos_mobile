import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../controllers/attendance_transaction_controller.dart';

class AttendanceTransactionView extends GetView<AttendanceTransactionController> {
  const AttendanceTransactionView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Absensi', style: Get.textTheme.headlineLarge), toolbarHeight: 80),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: Get.width,
          child: Obx(() {
            if (controller.sendLoading.value) {
              return FilledButton(
                onPressed: null,
                child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator()),
              );
            }

            if (controller.user['is_absen'] == 'Y') {
              return FilledButton(onPressed: controller.sendExitAttendance, child: Text('Absen Keluar'));
            }

            if ([6, 7].contains(controller.user['level'])) {
              if (controller.schedule.value == null || !controller.inRadius.value) {
                return FilledButton(onPressed: null, child: Text('Kirim'));
              } else {
                return FilledButton(onPressed: controller.sendAttendance, child: Text('Kirim'));
              }
            } else {
              if (controller.selectedOutlet.value != null &&
                  controller.selectedShift.value != null &&
                  controller.inRadius.value) {
                return FilledButton(onPressed: controller.sendAttendance, child: Text('Kirim'));
              } else {
                return FilledButton(onPressed: null, child: Text('Kirim'));
              }
            }
          }),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: RefreshIndicator(
          onRefresh: controller.refreshPage,
          child: ListView(
            children: [
              Container(
                height: Get.height / 6,
                width: Get.width,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                child: Image.file(File(controller.pathFile)),
              ),
              const SizedBox(height: 10),
              Container(
                height: Get.height / 7,
                width: Get.width,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                ),
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(controller.location.latitude, controller.location.longitude),
                    initialZoom: 16.0,
                  ),
                  children: [
                    TileLayer(urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 40,
                          height: 40,
                          point: LatLng(controller.location.latitude, controller.location.longitude),
                          child: Icon(Icons.location_on, color: Colors.red, size: 40),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                ),
                child: Text(controller.namedLocation, style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),
              Obx(() {
                if (controller.user['is_absen'] == 'Y') {
                  var checkin = DateTime.parse(controller.user['check_in_time']);
                  return Container(
                    width: Get.width,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        Text('Data Absen Masuk', style: TextStyle(fontWeight: FontWeight.bold)),
                        DataTable(
                          columnSpacing: 10,
                          columns: [
                            DataColumn(label: Text('Check in')),
                            DataColumn(label: Text('Outlet')),
                            DataColumn(label: Text('Shift')),
                          ],
                          rows: [
                            DataRow(
                              cells: [
                                DataCell(Text(DateFormat('dd/MM/yyyy HH:mm').format(checkin))),
                                DataCell(Text(controller.user['outlet_name'])),
                                DataCell(Text(controller.user['shift_name'])),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  if ([6, 7].contains(controller.user['level'])) {
                    return _buildOperator();
                  } else {
                    if (controller.loadingSchedule.value) {
                      return SizedBox(height: 200, width: Get.width, child: Center(child: CircularProgressIndicator()));
                    } else {
                      return _buildNonOperator();
                    }
                  }
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildOperator() {
    return Container(
      width: Get.width,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Text('Jadwal', style: TextStyle(fontWeight: FontWeight.bold)),
          Obx(() {
            if (controller.loadingSchedule.value) {
              return Shimmer(
                child: Container(
                  decoration: BoxDecoration(color: Color(0xFFE8E8E8), borderRadius: BorderRadius.circular(15)),
                  child: DataTable(
                    columnSpacing: 30,
                    columns: [
                      DataColumn(label: Text('Tanggal', style: TextStyle(color: Colors.transparent))),
                      DataColumn(label: Text('Outlet', style: TextStyle(color: Colors.transparent))),
                      DataColumn(label: Text('Shift', style: TextStyle(color: Colors.transparent))),
                    ],
                    rows: [
                      DataRow(
                        cells: [
                          DataCell(Text('25/25/2025', style: TextStyle(color: Colors.transparent))),
                          DataCell(Text('Tanggulangin', style: TextStyle(color: Colors.transparent))),
                          DataCell(Text('Shift 1', style: TextStyle(color: Colors.transparent))),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else if (controller.schedule.value == null) {
              return Text('Tidak ada jadwal');
            } else {
              var date = DateTime.parse(controller.schedule.value?['date']);
              return DataTable(
                columnSpacing: 30,
                columns: [
                  DataColumn(label: Text('Tanggal')),
                  DataColumn(label: Text('Outlet')),
                  DataColumn(label: Text('Shift')),
                ],
                rows: [
                  DataRow(
                    cells: [
                      DataCell(Text(DateFormat('dd/MM/yyyy').format(date))),
                      DataCell(Text(controller.schedule.value?['outlet_name'])),
                      DataCell(Text(controller.schedule.value?['shift_name'])),
                    ],
                  ),
                ],
              );
            }
          }),
        ],
      ),
    );
  }

  Column _buildNonOperator() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: Get.width,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Column(
            children: [
              DropdownButtonFormField(
                decoration: InputDecoration(labelText: 'Pilih Outlet'),
                items:
                    controller.outlets.map((outlet) {
                      return DropdownMenuItem(value: outlet['id'], child: Text(outlet['name']));
                    }).toList(),
                onChanged: (value) {
                  controller.selectedOutlet.value = value as int;
                },
              ),
              Container(
                width: Get.width,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Shift', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    GridView.builder(
                      shrinkWrap: true, // ukuran menyesuaikan konten
                      physics: const NeverScrollableScrollPhysics(), // biar nggak scroll ganda
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // jumlah kolom
                        crossAxisSpacing: 8, // jarak horizontal antar item
                        mainAxisSpacing: 8, // jarak vertikal antar item
                        childAspectRatio: 3, // perbandingan lebar : tinggi
                      ),
                      itemCount: controller.shifts.length,
                      itemBuilder: (context, index) {
                        return Obx(() {
                          var shift = controller.shifts[index];
                          if (shift['id'] == controller.selectedShift.value) {
                            return FilledButton(onPressed: () {}, child: Text(shift['name']));
                          } else {
                            return OutlinedButton(
                              onPressed: () {
                                controller.selectedShift.value = shift['id'];
                              },
                              child: Text(shift['name']),
                            );
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
