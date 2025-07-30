import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:snpos/app/modules/main_nav/children/home/providers/home_provider.dart';

class HomeController extends GetxController {
  final HomeProvider provider;
  HomeController(this.provider);

  var isAbsenToday = false.obs;
  var isLoading = true.obs;
  var products = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAbsenStatus();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }


  Future<void> fetchAbsenStatus() async {
    try {
      isLoading.value = true;

      final response = await provider.getAbsenStatus();
      if (response.statusCode == 200) {
        isAbsenToday.value = response.body['data'] ?? false;
        fetchListProducts();
      } else {
        Get.snackbar('Error', 'Gagal ambil data');
        isLoading.value = false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan');
      isLoading.value = false;
    }
  }

  Future<void> fetchListProducts() async {
    try {
      isLoading.value = true;
      final response = await provider.getListProducts();
      if (response.statusCode == 200) {
        products.value = response.body['data'] ?? [];
      } else {
        Get.snackbar('Error', 'Gagal ambil data');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan');
    } finally {
      isLoading.value = false;
    }
  }

  String formatRupiah(dynamic number) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(number);
  }

  void addProduct(product) {
    final index = products.indexWhere((p) => p['id'] == product['id']);
    if (index != -1) {
      if(products[index]['cart'] == null) {
        products[index]['cart'] = 1;
      } else {
        products[index]['cart'] += 1;
      }
      products.refresh(); // penting agar UI update
    }
  }

  void removeProduct(product) {
    final index = products.indexWhere((p) => p['id'] == product['id']);
    if (index != -1) {
      if(products[index]['cart'] != 1) {
        products[index]['cart'] -= 1;
      } else {
        products[index].remove('cart');
      }
      products.refresh(); // penting agar UI update
    }
  }

}
