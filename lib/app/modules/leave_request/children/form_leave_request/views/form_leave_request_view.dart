import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:snpos/app/widgets/no_internet_widget.dart';

import '../controllers/form_leave_request_controller.dart';

class FormLeaveRequestView extends GetView<FormLeaveRequestController> {
  const FormLeaveRequestView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: ClipRRect(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
          child: AppBar(title: Text('Form Surat Izin Kerja'), backgroundColor: Get.theme.primaryColor, foregroundColor: Colors.white),
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
                  controller.submitLeave();
                }, child: Text('Buat Izin Kerja'));
              }
            }
        )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: RefreshIndicator(
          onRefresh: controller.fetchOperators,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Obx(
                    () {
                      final file = controller.attachedFile.value;

                  if (controller.state['loading']) {
                    return Center(child: CircularProgressIndicator());
                  } else if (controller.state['error']) {
                    return ListView(
                      children: [NoInternetWidget(onClickRefresh: () => controller.fetchOperators(), errorMessage: controller.state['message'])],
                    );
                  }
                  return ListView(
                    children: [
                      Text('Pilih Operator', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      DropdownButtonFormField(
                        value: controller.selectedOperator.value,
                        hint: Text('Pilih Operator'),
                        isExpanded: true,
                        items:
                        controller.operator.map((item) {
                          return DropdownMenuItem(value: item['id'], child: Text(item['name']));
                        }).toList(),
                        onChanged: (value) {
                          controller.selectedOperator.value = value as int?;
                        },
                      ),
                      SizedBox(height: 20),
                      Text('Kategori', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      DropdownButtonFormField(
                        value: controller.selectedCategory.value,
                        hint: Text('Pilih Kategori'),
                        isExpanded: true,
                        items:
                        controller.categories.map((item) {
                          return DropdownMenuItem(value: item['id'], child: Text(item['name']));
                        }).toList(),
                        onChanged: (value) {
                          controller.selectedCategory.value = value as int?;
                        },
                      ),

                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  Text('Tanggal Mulai', style: TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: controller.startDateController,
                                    readOnly: true,
                                    decoration: const InputDecoration(
                                      hintText: "Pilih tanggal mulai",
                                      suffixIcon: Icon(Icons.calendar_today),
                                    ),
                                    onTap: () => controller.pickStartDate(context),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tanggal Selesai', style: TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 10),
                            
                                TextFormField(
                                  controller: controller.endDateController,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    hintText: "Pilih tanggal selesai",
                                    suffixIcon: Icon(Icons.calendar_today),
                                  ),
                                  onTap: () => controller.pickEndDate(context),
                                ),
                              ],
                            ),
                          )


                        ],
                      ),



                      const SizedBox(height: 20),
                      Text('Catatan', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),

                      TextFormField(
                        controller: controller.remarksController,
                        decoration: const InputDecoration(
                          hintText: "Catatan",
                        ),
                      ),

                      const SizedBox(height: 20),
                      Text('Lampiran File', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            onPressed: controller.pickFromCamera,
                            icon: Icon(Icons.camera_alt),
                            label: Text("Kamera"),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton.icon(
                            onPressed: controller.pickFromGallery,
                            icon: Icon(Icons.image),
                            label: Text("Galeri"),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton.icon(
                            onPressed: controller.pickPdf,
                            icon: Icon(Icons.picture_as_pdf),
                            label: Text("PDF"),
                          ),
                        ],
                      ),
                      if (file != null) ...[
                        Text("Preview:", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),

                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (file.path.endsWith(".pdf")) ...[
                                Icon(Icons.picture_as_pdf, size: 40, color: Colors.red),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    file.path.split('/').last,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ] else ...[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    file,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],

                              IconButton(
                                onPressed: () => controller.attachedFile.value = null,
                                icon: Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  );
                }
            ),
          ),
        )
    );
  }
}
