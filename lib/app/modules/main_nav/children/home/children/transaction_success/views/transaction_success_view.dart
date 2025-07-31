import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snpos/app/routes/app_pages.dart';

import '../controllers/transaction_success_controller.dart';

class TransactionSuccessView extends GetView<TransactionSuccessController> {
  const TransactionSuccessView({super.key});
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:  () async {
        Get.offAllNamed(Routes.MAIN_NAV);
        return false; // prevent default pop
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final containerHeight = constraints.maxHeight;

                  return Obx(
                     () {
                      return Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            onEnd: controller.triggerCheckAnimation,
                            height: containerHeight - 60 - controller.topPosition.value,
                            width: Get.width,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Get.theme.primaryColor,
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(150), bottomLeft: Radius.circular(150)),
                            ),
                            child: Text('Transaksi Sukses', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, color: Colors.white, fontSize: 32),),
                          ),
                          Positioned(
                            bottom: 0,
                            child: AnimatedScale(
                              duration: Duration(milliseconds: 200),
                              scale: controller.showCheckIcon.value ? 1 : 0,
                              child: Container(
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(color: Get.theme.primaryColor, shape: BoxShape.circle, border: Border.all(width: 10, color: Get.theme.scaffoldBackgroundColor)),
                                child: Icon(Icons.check, size: 55, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  );
                },
              ),
            ),
            Expanded(
                flex: 3,
                child: Container(
                  margin: EdgeInsets.all(20),
                  alignment: Alignment.center,

                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...controller.products.map((product) {
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
                                Text(controller.formatRupiah(subtotal)),
                              ],
                            ),
                          );
                        }).toList(),

                        const Divider(color: Colors.black),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(controller.formatRupiah(controller.total), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Dibayarkan :', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(controller.formatRupiah(controller.paid), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Kembalian:', style: TextStyle(fontWeight: FontWeight.bold)),
                             Text(controller.formatRupiah(controller.paid - controller.total), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                      ],
                    ),
                  ),
              )
            ),
            Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              items: ['Item 1', 'Item 2', 'Item 3'].map((item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                );
                              }).toList(),
                              onChanged: (value) {
                                // ubah state/controller di sini
                              },
                            ),
                          ),
                          SizedBox(width: 20),
                          FilledButton(onPressed: () {}, child: Text('Hubungkan'))
                        ],
                      ),
                      SizedBox(height: 10),
                      SizedBox(width: Get.width, child: FilledButton(onPressed: () {}, style: FilledButton.styleFrom(backgroundColor: Color(0xffdbe7ff), foregroundColor: Colors.black), child: Text('Cetak Transaksi'))),
                      SizedBox(width: Get.width, child: FilledButton(onPressed: () => Get.offAllNamed(Routes.MAIN_NAV), child: Text('Kembali')))
                    ],
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}
