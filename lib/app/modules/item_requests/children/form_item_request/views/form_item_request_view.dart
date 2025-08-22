import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:snpos/app/widgets/no_internet_widget.dart';

import '../controllers/form_item_request_controller.dart';

class FormItemRequestView extends GetView<FormItemRequestController> {
  const FormItemRequestView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: ClipRRect(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
          child: Hero(tag: 'appbar', child: AppBar(title: Text('Permintaan Barang'), backgroundColor: Get.theme.primaryColor, foregroundColor: Colors.white)),
        ),
      ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(width: Get.width, child: Obx(
                  () {
                if(controller.loadingButton.value) {
                  return FilledButton(onPressed: null, child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(),));
                } else {
                  return FilledButton(onPressed: () {
                    FocusScope.of(context).unfocus();
                    controller.submitItemRequest();
                  }, child: Text('Request Perbaikan'));
                }
              }
          )),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: RefreshIndicator(
        onRefresh: controller.fetchItemsOutlets,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Obx(
            () {
              if (controller.state['loading']) {
                return Center(child: CircularProgressIndicator());
              } else if (controller.state['error']) {
                return ListView(
                  children: [NoInternetWidget(onClickRefresh: () => controller.fetchItemsOutlets(), errorMessage: controller.state['message'])],
                );
              }
              return ListView(
                children: [
                  Text('Pilih Barang', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  DropdownButtonFormField(
                    value: controller.selectedItem.value,
                    hint: Text('Pilih Barang'),
                    isExpanded: true,
                    items:
                    controller.items.map((item) {
                      return DropdownMenuItem(value: item['id'], child: Text(item['name']));
                    }).toList(),
                    onChanged: (value) {
                      print(value);
                      controller.selectedItem.value = value as int?;
                    },
                  ),
                  SizedBox(height: 20),
                  Text('Pilih Outlet', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  DropdownButtonFormField(
                    value: controller.selectedOutlet.value,
                    hint: Text('Pilih Outlet'),
                    isExpanded: true,
                    items:
                    controller.outlets.map((item) {
                      return DropdownMenuItem(value: item['id'], child: Text(item['name']));
                    }).toList(),
                    onChanged: (value) {
                      controller.selectedOutlet.value = value as int?;
                    },
                  ),
                  SizedBox(height: 20),

                  Text('Qty', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  TextField(
                    controller: controller.qtyController,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20),

                  // 4. Catatan
                  Text('Catatan', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  TextField(
                    controller: controller.noteController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      hintText: 'Masukkan catatan jika ada',
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              );
            }
          ),
        ),
      )
    );
  }
}
