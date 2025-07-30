import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snpos/app/modules/main_nav/children/home/views/not_absen_yet_view.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  // final formatCurrency = NumberFormat.currency(
  //   locale: 'id_ID',
  //   symbol: 'Rp ',
  //   decimalDigits: 0,
  // );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Katalog', style: Get.textTheme.headlineLarge), toolbarHeight: 80),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.isAbsenToday.value) {
          return RefreshIndicator(
            onRefresh: () => controller.fetchListProducts(),
            child: ListView.builder(
              itemCount: controller.products.length,
              itemBuilder:
                  (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          controller.addProduct(controller.products[index]);
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Icon Motor
                                Container(
                                  padding: EdgeInsets.all(12),
                                  margin: EdgeInsets.fromLTRB(12, 12, 0, 12),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(controller.products[index]['type'] == 'Motor' ? Icons.two_wheeler : Icons.directions_car, color: Colors.white),
                                ),
                                SizedBox(width: 12),

                                // Teks
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        controller.products[index]['name'],
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        controller.formatRupiah(
                                          controller.products[index]['price'],
                                        ),
                                        style: TextStyle(fontSize: 14, color: Colors.black87),
                                      ),
                                    ],
                                  ),
                                ),
                                controller.products[index]['cart'] != null ?
                                GestureDetector(
                                  onTap: () {
                                    controller.removeProduct(controller.products[index]);
                                  },
                                  child: Container(
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFFD3D3)
                                    ),
                                    child: Icon(Icons.remove, color: Colors.red, size: 24),
                                  ),
                                )
                                :
                                SizedBox(),
                                Container(
                                  width: 50,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFE7EEFB),
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                  ),
                                  child:
                                      controller.products[index]['cart'] != null
                                          ? Text(
                                            controller.products[index]['cart'].toString(),
                                            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 24, color: Colors.blue)
                                          )
                                          : Icon(Icons.add, color: Colors.blue, size: 24),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            ),
          );
        } else {
          return const NotAbsenYetView();
        }
      }),
    );
  }
}
