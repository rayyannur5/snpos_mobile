import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:snpos/app/config/constants.dart';
import 'package:snpos/app/widgets/no_internet_widget.dart';

import '../controllers/maintenance_approval_controller.dart';

class MaintenanceApprovalView extends GetView<MaintenanceApprovalController> {
  const MaintenanceApprovalView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: ClipRRect(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
          child: Hero(tag: 'appbar', child: AppBar(title: Text('Setujui Perbaikan'), backgroundColor: Get.theme.primaryColor, foregroundColor: Colors.white)),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: controller.fetchMaintenanceApprovals,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Obx(() {
            if (controller.state['loading']) {
              return Center(child: CircularProgressIndicator());
            } else if (controller.state['error']) {
              return ListView(
                children: [NoInternetWidget(onClickRefresh: () => controller.fetchMaintenanceApprovals(), errorMessage: controller.state['message'])],
              );
            } else if (controller.approvals.isEmpty) {
              return ListView(
                children: [
                  const SizedBox(height: 100),
                  Image.asset('assets/images/no_data.png'),
                  Text('Tidak ada data', textAlign: TextAlign.center, style: Get.textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold))
                ],
              );
            }

            return ListView(
              children: [
                ExpansionPanelList(
                    elevation: 0,
                    expansionCallback: (int index, bool isExpanded) {
                      controller.approvals[index]['isExpanded'] = isExpanded;
                      controller.approvals.refresh();
                    },
                    children: controller.approvals.map<ExpansionPanel>((item) {
                      return ExpansionPanel(
                        backgroundColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        canTapOnHeader: true,
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            title: Text(item['item_name']),
                            subtitle: Text(item['outlet_name']),
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
                                    SizedBox(width: 130, child: Text("Dikerjakan oleh", style: TextStyle(fontWeight: FontWeight.bold),)),
                                    Text(": ${item['done_by']}", style: TextStyle(fontWeight: FontWeight.bold),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: 130, child: Text("Tanggal", style: TextStyle(fontWeight: FontWeight.bold),)),
                                    Text(": ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(item['started_date']))}", style: TextStyle(fontWeight: FontWeight.bold),),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                // === Tombol aksi ===
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    FilledButton.icon(
                                      onPressed: () => controller.bottomSheetApprove(item),
                                      icon: const Icon(Icons.check),
                                      label: const Text("Verifikasi"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),


                        isExpanded: item['isExpanded'],
                      );
                    }).toList()
                ),
              ],
            );

          }),
        ),
      ),
    );
  }
}
