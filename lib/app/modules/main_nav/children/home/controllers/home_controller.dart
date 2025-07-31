import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:snpos/app/data/providers/db_helper.dart';
import 'package:snpos/app/modules/main_nav/children/home/providers/home_provider.dart';
import 'package:snpos/app/routes/app_pages.dart';

class HomeController extends GetxController {
  final HomeProvider provider;
  HomeController(this.provider);

  var isAbsenToday = false.obs;
  var isLoading = true.obs;
  var products = [].obs;
  var pendingTransactions = [].obs;

  var isBluetoothConnected = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAbsenStatus();

    DBHelper.getAllTransactions().then((value) async {
      pendingTransactions.value = value;
      print(value);

      for(var element in pendingTransactions) {
        var items = DBHelper.getItemTransaction(element['code']);
        Response response = await provider.sendListProducts(element, items);
        print("${DateTime.now()} delete ${element['code']}");
        if(response.statusCode == 200) {
          await DBHelper.deleteTransactions(element['code']);
          pendingTransactions.value = await DBHelper.getAllTransactions();
        }
      }
    });

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
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return formatter.format(number);
  }

  void addProduct(product) {
    final index = products.indexWhere((p) => p['id'] == product['id']);
    if (index != -1) {
      if (products[index]['cart'] == null) {
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
      if (products[index]['cart'] != 1) {
        products[index]['cart'] -= 1;
      } else {
        products[index].remove('cart');
      }
      products.refresh(); // penting agar UI update
    }
  }

  num get totalPrice {
    return products.fold(0, (sum, item) {
      final qty = item['cart'] ?? 0;
      final price = item['price'] ?? 0;
      return sum + (qty * price);
    });
  }

  void bottomSheetCheckout() {
    final selectedProducts = products.where((p) => (p['cart'] ?? 0) > 0).toList();
    final cashController = TextEditingController();
    final cashText = ''.obs;
    final formKey = GlobalKey<FormState>();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Color(0xffe4ecff), borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Ringkasan Pesanan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...selectedProducts.map((product) {
              final qty = product['cart'];
              final price = product['price'];
              final subtotal = qty * price;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black), // default style
                          children: [TextSpan(text: product['name'], style: const TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: ' x$qty')],
                        ),
                      ),
                    ),
                    Text(formatRupiah(subtotal)),
                  ],
                ),
              );
            }).toList(),
            const Divider(color: Colors.black),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(formatRupiah(totalPrice), style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Kembalian:', style: TextStyle(fontWeight: FontWeight.bold)),
                Obx( () {
                  final cash = int.tryParse(cashText.value.replaceAll('.', '')) ?? 0;
                  final kembalian = cash - totalPrice;
                    return Text(formatRupiah(kembalian), style: const TextStyle(fontWeight: FontWeight.bold));
                  }
                ),
              ],
            ),
            const SizedBox(height: 16),
            Form(
              key: formKey,
              child: TextFormField(
                controller: cashController,
                onChanged: (value) {
                  cashText.value = value;
                },
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  final cash = int.tryParse(value ?? '') ?? 0;
                  if (cash < totalPrice) {
                    return 'Uang tidak mencukupi';
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: 'Cash/Tunai', filled: true, fillColor: Colors.white),

              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    cashController.text = 5000.toString();
                    cashText.value = cashController.text;
                  },
                  child: Text(formatRupiah(5000)),
                ),
                ElevatedButton(
                  onPressed: () {
                    cashController.text = 10000.toString();
                    cashText.value = cashController.text;
                  },
                  child: Text(formatRupiah(10000)),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    cashController.text = 20000.toString();
                    cashText.value = cashController.text;
                  },
                  child: Text(formatRupiah(20000)),
                ),
                ElevatedButton(
                  onPressed: () {
                    cashController.text = 50000.toString();
                    cashText.value = cashController.text;
                  },
                  child: Text(formatRupiah(50000)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  _pay(formKey, cashText.value);
                },
                child: const Text('Bayar Sekarang'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _pay(formKey, paid) {

    final selectedProducts = products
        .where((p) => (p['cart'] ?? 0) > 0)
        .map((p) => Map<String, dynamic>.from(p))
        .toList();

    final num finalTotalPrice = totalPrice;
    final int paidAmount = int.tryParse(paid) ?? 0;
    final String trxCode = 'TRX-${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}';
    final String now = DateTime.now().toIso8601String();
    final int userId = 233; // ganti sesuai logika auth

    if (formKey.currentState!.validate()) {

      DBHelper.insertTransaction(
        code: trxCode,
        userId: userId,
        date: now,
        sell: finalTotalPrice.toInt(),
        pay: paidAmount,
        products: selectedProducts,
      );

      // lanjutkan ke transaksi
      Get.offAllNamed(
        Routes.TRANSACTION_SUCCESS,
        arguments: {
          'products': selectedProducts,
          'total': finalTotalPrice,
          'paid': int.tryParse(paid) ?? 0
        },
      );
    }
  }

  void bottomSheetConnectDevice() {
    Get.bottomSheet(
      Container(
        width: Get.width,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color(0xFFF2F4F7),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Text('Pilih Perangkat', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Container(
              width: Get.width,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ESP32', style: Get.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                  Text('A1:D3:34:1F:34', style: Get.textTheme.labelMedium),
                ],
              ),
            ),
            Container(
              width: Get.width,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ESP32', style: Get.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                  Text('A1:D3:34:1F:34', style: Get.textTheme.labelMedium),
                ],
              ),
            ),
            Spacer(),
            SizedBox(width: Get.width, child: FilledButton(onPressed: (){}, child: Text('Scan'))),
            const SizedBox(height: 20),
          ],
        ),
      )
    );
  }

}
