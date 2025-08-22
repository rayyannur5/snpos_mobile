import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:snpos/app/modules/item_requests/providers/item_request_provider.dart';

class ItemRequestsController extends GetxController {
  final ItemRequestProvider provider;
  ItemRequestsController(this.provider);

  var state = {}.obs;
  var requests = [].obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchRequests();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> fetchRequests() async {
    String token = box.read('token');
    state.value = {
      'loading': true,
      'error': false,
      'message': '',
    };
    final response = await provider.getRequests(token);
    if (response.statusCode == 200) {
      state.value = {
        'loading': false,
        'error': false,
        'message': '',
      };
      requests.value = response.body['data'];
    }
    else {
      state.value = {
        'loading': false,
        'error': true,
        'message': response.body['message'],
      };
    }
  }

}
