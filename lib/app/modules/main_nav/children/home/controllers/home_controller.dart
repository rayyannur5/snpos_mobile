import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:snpos/app/data/providers/db_helper.dart';
import 'package:snpos/app/enums/absen_status.dart';
import 'package:snpos/app/modules/main_nav/children/home/providers/home_provider.dart';
import 'package:snpos/app/routes/app_pages.dart';
import 'package:snpos/app/utils/currency_formatter.dart';
import 'package:snpos/app/utils/delete_photo.dart';

class HomeController extends GetxController {
  final HomeProvider provider;

  HomeController(this.provider);

  final box = GetStorage();

  var absenStatus = AbsenStatus.IsNotAbsen.obs;
  var isLoading = false.obs;
  var products = [].obs;
  var pendingTransactions = [].obs;

  var isBluetoothConnected = false.obs;

  var paymentMethod = [].obs;
  var cashUnit = [].obs;
  var shortcutRemarks = [].obs;

  var pathTakePicture = ''.obs;

  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();

    refreshPage();

    String token = box.read('token');

    DBHelper.getAllTransactions().then((value) async {
      pendingTransactions.value = value;


      for (var element in pendingTransactions) {
        var items = await DBHelper.getItemTransaction(element['code']);
        print(items);
        Response response = await provider.sendListProducts(element, items, token);
        print("${DateTime.now()} delete ${element['code']}");

        if (response.statusCode == 201) {

          await DBHelper.deleteTransactions(element['code']);
          pendingTransactions.value = await DBHelper.getAllTransactions();

        } else {

          if(response.body['message'].toLowerCase().contains('duplicate entry')) {
            await DBHelper.deleteTransactions(element['code']);
            pendingTransactions.value = await DBHelper.getAllTransactions();
          } else {
            Get.snackbar('Gagal Kirim Transaksi', response.body['message'], backgroundColor: Colors.red, colorText: Colors.white);
          }

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

  Future<void> fetchListProducts() async {
    try {
      String token = box.read('token');

      isLoading.value = true;
      errorMessage.value = '';
      final response = await provider.getListProducts(token);
      if (response.statusCode == 200) {
        products.value = response.body['data'] ?? [];
      } else {
        Get.snackbar('Error', response.body.message, backgroundColor: Colors.red, colorText: Colors.white);
        errorMessage.value = response.body.message;
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan', backgroundColor: Colors.red, colorText: Colors.white);
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
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
    final remarkController = TextEditingController();
    final cashText = ''.obs;
    final formKey = GlobalKey<FormState>();
    final selectedPayment = {}.obs;


    Get.bottomSheet(
      DraggableScrollableSheet(
        initialChildSize: 0.98,
        minChildSize: 0.5,
        maxChildSize: 0.98,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Color(0xffe4ecff), borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  const SizedBox(height: 10),
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
                          Text(CurrencyFormatter.toRupiah(subtotal)),
                        ],
                      ),
                    );
                  }).toList(),
                  const Divider(color: Colors.black),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(CurrencyFormatter.toRupiah(totalPrice), style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Kembalian:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Obx(() {
                        final cash = int.tryParse(cashText.value.replaceAll('.', '')) ?? 0;
                        final kembalian = cash - totalPrice;
                        return Text(CurrencyFormatter.toRupiah(kembalian), style: const TextStyle(fontWeight: FontWeight.bold));
                      }),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    if (paymentMethod.isNotEmpty) {
                      return GridView.builder(
                        shrinkWrap: true, // ukuran menyesuaikan konten
                        physics: const NeverScrollableScrollPhysics(), // biar nggak scroll ganda
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // jumlah kolom
                          crossAxisSpacing: 8, // jarak horizontal antar item
                          mainAxisSpacing: 8, // jarak vertikal antar item
                          childAspectRatio: 4, // perbandingan lebar : tinggi
                        ),
                        itemCount: paymentMethod.length,
                        itemBuilder: (context, index) {
                          return Obx(() {
                            if (paymentMethod[index]['id'] == selectedPayment['id']) {
                              return FilledButton(onPressed: () {}, child: Text(paymentMethod[index]['name']));
                            } else {
                              return OutlinedButton(
                                onPressed: () {
                                  selectedPayment.value = paymentMethod[index];
                                  if(selectedPayment['is_fully_paid'] == 1) {
                                    cashText.value = totalPrice.toString();
                                    cashController.text = '';
                                    formKey.currentState?.reset();
                                  }
                                },
                                child: Text(paymentMethod[index]['name']),
                              );
                            }
                          });
                        },
                      );
                    } else {
                      return Container(child: Text('Tidak ada metode payment'));
                    }
                  }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Obx(() {
                          if (pathTakePicture.value != '') {
                            return Image.file(File(pathTakePicture.value), width: 100, height: 100);
                          } else {
                            return Image.asset('assets/images/no_data.png', width: 100, height: 100);
                          }
                        }),
                      ),
                      Obx(() {
                        if (pathTakePicture.value != '') {
                          return IconButton.outlined(
                            onPressed: () async {
                              await DeletePhoto.deletePhoto(pathTakePicture.value);
                              pathTakePicture.value = '';
                            },
                            color: Colors.red,
                            icon: Icon(Icons.delete),
                          );
                        } else {
                          return Container();
                        }
                      }),
                      ElevatedButton(
                        onPressed: () async {
                          pathTakePicture.value = await Get.toNamed(Routes.CAMERA_PICKER);
                        },
                        child: Text('Ambil Gambar'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    return Form(
                      key: formKey,
                      child: TextFormField(
                        enabled: selectedPayment['is_fully_paid'] == 0,
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
                    );
                  }),
                  const SizedBox(height: 16),
                  cashUnit.isNotEmpty ?
                  GridView.builder(
                    shrinkWrap: true, // ukuran menyesuaikan konten
                    physics: const NeverScrollableScrollPhysics(), // biar nggak scroll ganda
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // jumlah kolom
                      crossAxisSpacing: 8, // jarak horizontal antar item
                      mainAxisSpacing: 8, // jarak vertikal antar item
                      childAspectRatio: 4, // perbandingan lebar : tinggi
                    ),
                    itemCount: cashUnit.length,
                    itemBuilder: (context, index) {
                      return Obx(() {
                        return ElevatedButton(
                          onPressed: selectedPayment['is_fully_paid'] == 0 ? () {
                            cashController.text = cashUnit[index]['amount'].toString();
                            cashText.value = cashUnit[index]['amount'].toString();
                          }  : null,
                          child: Text(CurrencyFormatter.toRupiah(cashUnit[index]['amount'])),
                        );
                      });
                    },
                  )
                      : Container(child: Text('Tidak ada cash unit')),
                  const SizedBox(height: 16),
                  TextField(controller: remarkController, decoration: InputDecoration(labelText: 'Catatan', filled: true, fillColor: Colors.white)),
                  const SizedBox(height: 16),
                  shortcutRemarks.isNotEmpty ?
                  GridView.builder(
                    shrinkWrap: true, // ukuran menyesuaikan konten
                    physics: const NeverScrollableScrollPhysics(), // biar nggak scroll ganda
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // jumlah kolom
                      crossAxisSpacing: 8, // jarak horizontal antar item
                      mainAxisSpacing: 8, // jarak vertikal antar item
                      childAspectRatio: 3, // perbandingan lebar : tinggi
                    ),
                    itemCount: shortcutRemarks.length,
                    itemBuilder: (context, index) {
                      return Obx(() {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(padding: EdgeInsets.all(5)),
                          onPressed: () => remarkController.text = shortcutRemarks[index]['name'],
                          child: Text(shortcutRemarks[index]['name'], textAlign: TextAlign.center, style: TextStyle(fontSize: 10),),
                        );
                      });
                    },
                  ): SizedBox(),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: Obx(
                      () {
                        return FilledButton(
                          onPressed: selectedPayment.containsKey('id') ? ()  {
                            if(selectedPayment['is_need_picture'] == 1 && pathTakePicture.value == '') {
                              Get.snackbar('Gagal', 'Harap ambil gambar terlebih dahulu', backgroundColor: Colors.red, colorText: Colors.white);
                              return;
                            }

                            if(selectedPayment['is_fully_paid'] == 0 && !formKey.currentState!.validate()) {
                              return;
                            }

                            _pay(selectedPayment['id'], selectedPayment['is_fully_paid'], cashController.text, remarkController.text, pathTakePicture.value);
                          } : null,
                          child: const Text('Bayar Sekarang'),
                        );
                      }
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        }
      ),
      isScrollControlled: true,
    );
  }

  void _pay(payment_method, isFullyPaid, paid, remarks, path) async {

    try {
      final selectedProducts = products.where((p) => (p['cart'] ?? 0) > 0).map((p) => Map<String, dynamic>.from(p)).toList();

      final user = box.read('user');

      final num finalTotalPrice = totalPrice;
      final int paidAmount = isFullyPaid == 1 ? finalTotalPrice.toInt() : int.tryParse(paid) ?? 0;
      final String trxCode = 'TRX-${user['id']}-${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}';
      final String now = DateTime.now().toIso8601String();
      final int userId = box.read('user')['id'];; // ganti sesuai logika auth

      var result = await DBHelper.insertTransaction(
          code: trxCode,
          userId: userId,
          date: now,
          sell: finalTotalPrice.toInt(),
          pay: paidAmount,
          products: selectedProducts,
          payment_method: payment_method,
          remarks: remarks,
          path: path
      );

      // lanjutkan ke transaksi
      Get.offAllNamed(
        Routes.TRANSACTION_SUCCESS,
        arguments: {'products': selectedProducts, 'total': finalTotalPrice, 'paid': paidAmount},
      );
    } on Exception catch(e) {
      print(e);
      Get.snackbar('Gagal', e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    }

  }

  void bottomSheetConnectDevice() {
    Get.bottomSheet(
      Container(
        width: Get.width,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(color: Get.theme.scaffoldBackgroundColor, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(
          children: [
            Text('Pilih Perangkat', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Container(
              width: Get.width,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
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
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ESP32', style: Get.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                  Text('A1:D3:34:1F:34', style: Get.textTheme.labelMedium),
                ],
              ),
            ),
            Spacer(),
            SizedBox(width: Get.width, child: FilledButton(onPressed: () {}, child: Text('Scan'))),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> refreshPage() async {
    isLoading.value = true;
    errorMessage.value = '';
    await getPaymentMethod();
    var response = await provider.updateUserData(box.read('token'));
    if (response.statusCode == 200) {
      var user = response.body['data'];
      box.write('user', user);

      if (user['is_absen'] == 'Y') {
        absenStatus.value = AbsenStatus.IsAbsen;

        await fetchListProducts();
      } else if (user['is_absen'] == 'N') {
        absenStatus.value = AbsenStatus.IsNotAbsen;
      } else if (user['is_absen'] == 'X') {
        absenStatus.value = AbsenStatus.AfterAbsen;
      }
    } else {
      errorMessage.value = response.body['message'];
    }

    isLoading.value = false;
  }

  Future<void> getPaymentMethod() async {
    String token = box.read('token');
    var response = await provider.getPaymentMethod(token);
    if (response.statusCode == 200) {
      paymentMethod.value = response.body['data']['payments'];
      cashUnit.value = response.body['data']['cash_units'];
      shortcutRemarks.value = response.body['data']['shortcut_remarks'];
    } else {
      Get.snackbar('Gagal mengambil data', response.body['message'], backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

}
