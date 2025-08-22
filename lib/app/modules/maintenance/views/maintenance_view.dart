import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:snpos/app/config/constants.dart';
import 'package:snpos/app/routes/app_pages.dart';
import 'package:snpos/app/widgets/no_internet_widget.dart';

import '../controllers/maintenance_controller.dart';

class MaintenanceView extends GetView<MaintenanceController> {
  const MaintenanceView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: ClipRRect(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
          child: Hero(tag: 'appbar', child: AppBar(title: Text('Perbaikan'), backgroundColor: Get.theme.primaryColor, foregroundColor: Colors.white)),
        ),
      ),
      floatingActionButton: FilledButton.icon(
        onPressed: () => Get.toNamed(Routes.MAINTENANCE_REQUEST),
        label: Text('Request Perbaikan'),
        icon: Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: controller.fetchMaintenance,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Obx(() {
            if (controller.state['loading']) {
              return Center(child: CircularProgressIndicator());
            } else if (controller.state['error']) {
              return ListView(
                children: [NoInternetWidget(onClickRefresh: () => controller.fetchMaintenance(), errorMessage: controller.state['message'])],
              );
            } else if (controller.maintenance.isEmpty) {
              return ListView(
                children: [
                  const SizedBox(height: 100),
                  Image.asset('assets/images/no_data.png'),
                  Text('Tidak ada data', textAlign: TextAlign.center, style: Get.textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold)),
                ],
              );
            }

            return ListView(
              children: [
                ExpansionPanelList(
                  elevation: 0,
                  expansionCallback: (int index, bool isExpanded) {
                    controller.maintenance[index]['isExpanded'] = isExpanded;
                    controller.maintenance.refresh();
                  },
                  children:
                      controller.maintenance.map<ExpansionPanel>((item) {
                        return ExpansionPanel(
                          backgroundColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          canTapOnHeader: true,
                          headerBuilder: (BuildContext context, bool isExpanded) {
                            return ListTile(
                              title: Text(item['item_name']),
                              subtitle: Text(item['outlet_name']),
                              trailing: Badge(
                                label: Text(item['status']),
                                backgroundColor: item['started_date'] != null ? Colors.green : Colors.orange,
                              ),
                            );
                          },
                          body: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // === Foto Request ===
                                  GestureDetector(
                                    onTap: () => controller.dialogPicture(item),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        "${AppConstants.storageUrl}/${item['request_picture']}",
                                        height: 180,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            height: 180,
                                            color: Colors.grey[300],
                                            alignment: Alignment.center,
                                            child: const Icon(Icons.broken_image, size: 40),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  // === Detail dengan titik dua sejajar ===
                                  Row(
                                    children: [
                                      SizedBox(width: 140, child: Text("Request oleh", style: TextStyle(fontWeight: FontWeight.bold))),
                                      Text(": ${item['request_name']}", style: TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(width: 140, child: Text("Status", style: TextStyle(fontWeight: FontWeight.bold))),
                                      Text(": ${item['status']}", style: TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(width: 140, child: Text("Dikerjakan oleh", style: TextStyle(fontWeight: FontWeight.bold))),
                                      Text(": ${item['maintenance_name'] ?? '-'}", style: TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(width: 140, child: Text("Tanggal Request", style: TextStyle(fontWeight: FontWeight.bold))),
                                      Text(
                                        ": ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(item['request_date']))}",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(width: 140, child: Text("Tanggal Dibagikan", style: TextStyle(fontWeight: FontWeight.bold))),
                                      Text(
                                        ": ${ item['accepted_date'] != null ? DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(item['accepted_date']) ) : '-' }",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(width: 140, child: Text("Tanggal Dikerjakan", style: TextStyle(fontWeight: FontWeight.bold))),
                                      Text(
                                        ": ${ item['started_date'] != null ? DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(item['started_date']) ) : '-' }",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(width: 140, child: Text("Tanggal Verifikasi", style: TextStyle(fontWeight: FontWeight.bold))),
                                      Text(
                                        ": ${ item['approved_date'] != null ? DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(item['approved_date']) ) : '-' }",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),


                                  const SizedBox(height: 12),

                                  // === Tombol aksi ===
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Builder(
                                        builder: (context) {
                                          if (item['status'] == 'Belum Dibagikan') {
                                            return FilledButton.icon(onPressed: null, icon: const Icon(Icons.check), label: Text(item['status']));
                                          } else if (item['status'] == 'Belum Dikerjakan') {
                                            return FilledButton.icon(
                                              onPressed: () => controller.dialogJob(item),
                                              icon: const Icon(Icons.check),
                                              label: const Text("Kerjakan"),
                                            );
                                          } else if (item['status'] == 'Sedang Dikerjakan') {
                                            if (item['request_by'] == controller.user['id']) {
                                              return FilledButton.icon(onPressed: () => controller.bottomSheetApprove(item), icon: const Icon(Icons.check), label: Text('Verifikasi'));
                                            } else {
                                              return FilledButton.icon(onPressed: null, icon: const Icon(Icons.check), label: Text(item['status']));
                                            }
                                          } else {
                                            return FilledButton.icon(onPressed: null, icon: const Icon(Icons.check), label: Text(item['status']));
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          isExpanded: item['isExpanded'],
                        );
                      }).toList(),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
