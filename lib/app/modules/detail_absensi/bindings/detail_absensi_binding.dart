import 'package:get/get.dart';
import 'package:snpos/app/modules/detail_absensi/providers/detail_absensi_provider.dart';
import 'package:snpos/app/modules/detail_absensi/providers/detail_absensi_provider.dart';

import '../controllers/detail_absensi_controller.dart';

class DetailAbsensiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailAbsensiProvider>(
      () => DetailAbsensiProvider(),
    );

    Get.lazyPut<DetailAbsensiController>(
      () => DetailAbsensiController(Get.find()),
    );
  }
}
