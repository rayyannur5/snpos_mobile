import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:snpos/app/widgets/no_internet_widget.dart';

import '../controllers/overtime_application_controller.dart';

class OvertimeApplicationView extends GetView<OvertimeApplicationController> {
  const OvertimeApplicationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: ClipRRect(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
          child: Hero(
            tag: 'appbar',
            child: AppBar(title: Text('Pengajuan Lembur'), backgroundColor: Get.theme.primaryColor, foregroundColor: Colors.white),
          ),
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
                controller.submitOvertime();
              }, child: Text('Ajukan Lembur'));
            }
          }
        )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: RefreshIndicator(
        onRefresh: controller.fetchOperators,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Obx(
            () {
              if(controller.status['loading']) {
                return Center(child: CircularProgressIndicator(),);
              } else if (controller.status['error']) {
                return SingleChildScrollView(child: NoInternetWidget(onClickRefresh: () => controller.fetchOperators(), errorMessage: controller.status['message']));
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
                    controller.operators.map((operator) {
                      return DropdownMenuItem(value: operator['id'], child: Text(operator['name']));
                    }).toList(),
                    onChanged: (value) {
                      print(value);
                      controller.selectedOperator.value = value as int?;
                    },
                  ),
                  SizedBox(height: 20),

                  // 2. Select Date
                  Text('Pilih Tanggal', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Obx(
                    () => InkWell(
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: controller.selectedDate.value ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          controller.selectedDate.value = picked;
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(30)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller.selectedDate.value == null
                                  ? 'Pilih Tanggal'
                                  : '${controller.selectedDate.value!.day}/${controller.selectedDate.value!.month}/${controller.selectedDate.value!.year}',
                              style: TextStyle(fontSize: 16),
                            ),
                            Icon(Icons.calendar_today, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  Text('Pilih Outlet', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  DropdownButtonFormField(
                    value: controller.selectedOutlet.value,
                    hint: Text('Pilih Outlet'),
                    isExpanded: true,
                    items:
                    controller.outlets.map((operator) {
                      return DropdownMenuItem(value: operator['id'], child: Text(operator['name']));
                    }).toList(),
                    onChanged: (value) {
                      print(value);
                      controller.selectedOutlet.value = value as int?;
                    },
                  ),
                  SizedBox(height: 20),

                  // 3. Select Shift pakai GridView
                  Text('Pilih Shift', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Obx(
                    () => GridView.count(
                      crossAxisCount: 3, // jumlah kolom
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      shrinkWrap: true, // penting agar GridView tidak mengambil seluruh height
                      childAspectRatio: 2.5,
                      physics: NeverScrollableScrollPhysics(), // agar ListView tetap scrollable
                      children:
                          controller.shifts.map((shift) {
                            bool isSelected = controller.selectedShift.value == shift['id'];
                            return FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: isSelected ? Get.theme.primaryColor : Colors.grey[300],
                                foregroundColor: isSelected ? Colors.white : Colors.black,
                              ),
                              onPressed: () {
                                controller.onShiftChanged(shift);
                              },
                              child: Text(shift['name']),
                            );
                          }).toList(),
                    ),
                  ),
                  SizedBox(height: 20),

                  Row(children: [
                    Obx(() => Expanded(
                      child: Card(
                        child: ListTile(
                          title: Text("Start Time"),
                          subtitle: Text(
                            controller.formatTime24(controller.startTime.value),
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          trailing: Icon(Icons.access_time),
                          onTap: () => controller.pickStartTime(context),
                        ),
                      ),
                    )),
                    SizedBox(height: 10),

                    Obx(() => Expanded(
                      child: Card(
                        child: ListTile(
                          title: Text("End Time"),
                          subtitle: Text(
                            controller.formatTime24(controller.endTime.value),
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          trailing: Icon(Icons.access_time),
                          onTap: () => controller.pickEndTime(context),
                        ),
                      ),
                    )),

                  ],),
                  SizedBox(height: 20),

                  // 4. Catatan
                  Text('Catatan', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  TextField(
                    controller: controller.noteController,
                    maxLines: 3,
                    decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)), hintText: 'Masukkan catatan jika ada'),
                  ),
                  SizedBox(height: 20),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}
