import 'package:get/get.dart';
import 'package:snpos/app/data/providers/base_api_provider.dart';

class ItemRequestProvider extends BaseApiProvider {
  Future<Response> getRequests(token) async {
    Response response = await get('/item_requests/lists', headers: {'Authorization': 'Bearer $token'});
    return createResponse(response);
  }

  Future<Response> getItemsOutlets(token) async {
    Response response = await get('/item_requests/items_and_outlets', headers: {'Authorization': 'Bearer $token'});
    return createResponse(response);
  }

  Future<Response> submitItemRequest(token, item_id, outlet_id, qty, note) async {
    Response response = await post('/item_requests/create', {'item_id': item_id, 'outlet_id': outlet_id, 'qty': qty, 'note': note}, headers: {'Authorization': 'Bearer $token'});
    return createResponse(response);
  }
}
