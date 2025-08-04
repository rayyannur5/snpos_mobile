import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../controllers/attendance_transaction_controller.dart';

class AttendanceTransactionView extends GetView<AttendanceTransactionController> {
  const AttendanceTransactionView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Absensi', style: Get.textTheme.headlineLarge), toolbarHeight: 80),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                width: Get.width,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                child: Image.file(File(controller.pathFile)),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              flex: 2,
              child: Container(
                width: Get.width,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
                child: FlutterMap(
                  options: MapOptions(initialCenter: LatLng(controller.location.latitude, controller.location.longitude), initialZoom: 16.0),
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
            ),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
              child: Text(controller.namedLocation, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            Container(
              width: Get.width,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Outlet', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Obx(() {
                    if (controller.outlets.isEmpty) {
                      return Shimmer(child: SizedBox(width: Get.width, child: FilledButton(onPressed: null, child: Text(''))));
                    } else {
                      return DropdownButtonFormField(
                        isExpanded: true,
                        onChanged: (e) => controller.selectOutlet(e),
                        decoration: InputDecoration(labelText: 'Pilih Outlet'),
                        items:
                            controller.outlets.map((e) {
                              return DropdownMenuItem(value: e['id'], child: Text(e['name']));
                            }).toList(),
                      );
                    }
                  }),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: Get.width,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Outlet', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Obx(() {
                    if (controller.shifts.isEmpty) {
                      return Shimmer(child: SizedBox(width: Get.width, child: FilledButton(onPressed: null, child: Text(''))));
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:
                            controller.shifts.map((e) {
                              if (e['id'] == controller.selectedShift.value) {
                                return FilledButton(onPressed: () {}, child: Text(e['name']));
                              } else {
                                return OutlinedButton(onPressed: () => controller.selectShift(e['id']), child: Text(e['name']));
                              }
                            }).toList(),
                      );
                    }
                  }),
                ],
              ),
            ),
            Spacer(),
            SizedBox(
              width: Get.width,
              child: Obx(() {
                if (controller.sendLoading.value) {
                  return FilledButton(onPressed: null, child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator()));
                }
                {
                  return FilledButton(onPressed: controller.sendAttendance, child: Text('Kirim'));
                }
              }),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
