import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:snpos/app/config/constants.dart';
import 'package:snpos/app/routes/app_pages.dart';
import 'package:snpos/app/widgets/no_internet_widget.dart';

import '../controllers/leave_request_controller.dart';

class LeaveRequestView extends GetView<LeaveRequestController> {
  const LeaveRequestView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: ClipRRect(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
          child: Hero(
            tag: 'appbar',
            child: AppBar(title: Text('Surat Izin Kerja'), backgroundColor: Get.theme.primaryColor, foregroundColor: Colors.white),
          ),
        ),
      ),
      floatingActionButton: FilledButton.icon(
        onPressed: () async {
          await Get.toNamed(Routes.FORM_LEAVE_REQUEST);
          controller.fetchRequests();
        },
        label: Text('Buat Izin'),
        icon: Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: controller.fetchRequests,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Obx(() {
            if (controller.state['loading']) {
              return Center(child: CircularProgressIndicator());
            } else if (controller.state['error']) {
              return ListView(
                children: [NoInternetWidget(onClickRefresh: () => controller.fetchRequests(), errorMessage: controller.state['message'])],
              );
            } else if (controller.requests.isEmpty) {
              return ListView(
                children: [
                  const SizedBox(height: 100),
                  Image.asset('assets/images/no_data.png'),
                  Text('Tidak ada data', textAlign: TextAlign.center, style: Get.textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold)),
                ],
              );
            }

            return SingleChildScrollView(
              child: ExpansionPanelList(
                elevation: 0,
                expansionCallback: (int index, bool isExpanded) {
                  controller.requests[index]['isExpanded'] = isExpanded;
                  controller.requests.refresh();
                },
                children:
                    controller.requests.map<ExpansionPanel>((item) {
                      return ExpansionPanel(
                        backgroundColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        canTapOnHeader: true,
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            title: Text(item['category_name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(
                              "${DateFormat('dd/MM/yyyy').format(DateTime.parse(item['start_date']))} - ${DateFormat('dd/MM/yyyy').format(DateTime.parse(item['end_date']))}",
                              style: Get.textTheme.bodySmall,
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: _statusColor(item['status']).withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                              child: Text(
                                item['status'],
                                style: TextStyle(color: _statusColor(item['status']), fontWeight: FontWeight.bold, fontSize: 12),
                              ),
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
                                item['additional_file'] != null && item['additional_file'] != ''
                                    ? item['additional_file'].endsWith('.pdf')
                                        ? GestureDetector(
                                  onTap: () => controller.dialogPDF(item['additional_file']),
                                          child: Container(
                                            height: 180,
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.all(20),
                                            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Icon(Icons.picture_as_pdf, size: 100, color: Get.theme.primaryColor),
                                                Text(item['additional_file'], style: Get.textTheme.bodySmall)
                                              ],
                                            ),
                                          ),
                                        )
                                        : GestureDetector(
                                          onTap: () => controller.dialogPicture(item['additional_file']),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.network(
                                              "${AppConstants.storageUrl}/${item['additional_file']}",
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
                                        )
                                    : Container(
                                      height: 180,
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8)),
                                      child: Image.asset('assets/images/no_data.png'),
                                    ),

                                const SizedBox(height: 12),

                                // === Detail dengan titik dua sejajar ===
                                Row(
                                  children: [
                                    SizedBox(width: 100, child: Text("Nama", style: TextStyle(fontWeight: FontWeight.bold))),
                                    Text(": ${item['user_name']}", style: TextStyle(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: 100, child: Text("Kategori", style: TextStyle(fontWeight: FontWeight.bold))),
                                    Text(": ${item['category_name']}", style: TextStyle(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: 100, child: Text("Status", style: TextStyle(fontWeight: FontWeight.bold))),
                                    Text(": ${item['status'] ?? '-'}", style: TextStyle(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: 100, child: Text("Tanggal", style: TextStyle(fontWeight: FontWeight.bold))),
                                    Text(
                                      ": ${DateFormat('dd/MM/yyyy').format(DateTime.parse(item['start_date']))} - ${DateFormat('dd/MM/yyyy').format(DateTime.parse(item['end_date']))}",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: 100, child: Text("Catatan", style: TextStyle(fontWeight: FontWeight.bold))),
                                    Text(": ${item['remarks']}", style: TextStyle(fontWeight: FontWeight.bold)),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                // === Tombol aksi ===
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.end,
                                //   children: [
                                //     Builder(
                                //       builder: (context) {
                                //         if (item['status'] == 'Belum Dibagikan') {
                                //           return FilledButton.icon(onPressed: null, icon: const Icon(Icons.check), label: Text(item['status']));
                                //         } else if (item['status'] == 'Belum Dikerjakan') {
                                //           return FilledButton.icon(
                                //             // onPressed: () => controller.dialogJob(item),
                                //             icon: const Icon(Icons.check),
                                //             label: const Text("Kerjakan"),
                                //           );
                                //         } else if (item['status'] == 'Sedang Dikerjakan') {
                                //           if (item['request_by'] == controller.user['id']) {
                                //             return FilledButton.icon(onPressed: () => controller.bottomSheetApprove(item), icon: const Icon(Icons.check), label: Text('Verifikasi'));
                                //           } else {
                                //             return FilledButton.icon(onPressed: null, icon: const Icon(Icons.check), label: Text(item['status']));
                                //           }
                                //         } else {
                                //           return FilledButton.icon(onPressed: null, icon: const Icon(Icons.check), label: Text(item['status']));
                                //         }
                                //       },
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                        ),
                        isExpanded: item['isExpanded'],
                      );
                    }).toList(),
              ),
            );
          }),
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case "ACCEPTED":
        return Colors.green;
      case "REJECTED":
        return Colors.red;
      case "CANCELED":
        return Colors.grey;
      case "REQUESTED":
      default:
        return Colors.orange;
    }
  }

  IconData _getStatusIcon(status) {
    switch (status) {
      case 'APPROVED':
        return Icons.check_circle_outline;
      case 'ACCEPTED':
        return Icons.inventory_2_outlined;
      case 'CANCELED':
        return Icons.cancel_outlined;
      default:
        return Icons.hourglass_bottom;
    }
  }
}
