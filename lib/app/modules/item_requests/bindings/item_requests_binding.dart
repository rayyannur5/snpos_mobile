import 'package:get/get.dart';
import 'package:snpos/app/modules/item_requests/providers/item_request_provider.dart';

import '../controllers/item_requests_controller.dart';

class ItemRequestsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ItemRequestProvider());
    Get.lazyPut<ItemRequestsController>(
      () => ItemRequestsController(Get.find()),
    );
  }
}
