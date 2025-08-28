import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:snpos/app/enums/absen_status.dart';
import 'package:snpos/app/routes/app_pages.dart';

class DashboardController extends GetxController {

  var absenStatus = AbsenStatus.IsNotAbsen.obs;

  late var user;
  final box = GetStorage();

  final List<Map<String, dynamic>> menus = [
    {
      "title": "Pengajuan Lembur",
      "icon": Icons.access_time,
      "route": Routes.OVERTIME_APPLICATION,
      "color": Color(0xFFB3E5FC), // pastel biru
      "iconColor": Color(0xFF0288D1),
    },
    {
      "title": "Perbaikan",
      "icon": Icons.build,
      "route": Routes.MAINTENANCE,
      "color": Color(0xFFFFF9C4), // pastel kuning
      "iconColor": Color(0xFFFBC02D),
    },
    {
      "title": "Permintaan Barang",
      "icon": Icons.shopping_cart,
      "route": Routes.ITEM_REQUESTS,
      "color": Color(0xFFC8E6C9), // pastel hijau
      "iconColor": Color(0xFF388E3C),
    },
    {
      "title": "Pengajuan Ijin",
      "icon": Icons.event,
      "route": Routes.LEAVE_REQUEST,
      "color": Color(0xFFFFCDD2), // pastel merah muda
      "iconColor": Color(0xFFD32F2F),
    },
  ];

  @override
  void onInit() {
    super.onInit();

    refreshPage();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> refreshPage() async {
    user = box.read('user');

    if (user['is_absen'] == 'Y') {
      absenStatus.value = AbsenStatus.IsAbsen;
    } else if (user['is_absen'] == 'N') {
      absenStatus.value = AbsenStatus.IsNotAbsen;
    } else if (user['is_absen'] == 'X') {
      absenStatus.value = AbsenStatus.AfterAbsen;
    }
  }
}
