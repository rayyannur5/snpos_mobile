import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:snpos/app/config/constants.dart';
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
      body: RefreshIndicator(
        onRefresh: controller.fetchMaintenanceJobs,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Obx(() {
            if (controller.state['loading']) {
              return Center(child: CircularProgressIndicator());
            } else if (controller.state['error']) {
              return ListView(
                children: [NoInternetWidget(onClickRefresh: () => controller.fetchMaintenanceJobs(), errorMessage: controller.state['message'])],
              );
            } else if (controller.jobs.isEmpty) {
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
                    controller.jobs[index]['isExpanded'] = isExpanded;
                    controller.jobs.refresh();
                  },
                  children: controller.jobs.map<ExpansionPanel>((item) {
                    return ExpansionPanel(
                      backgroundColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      canTapOnHeader: true,
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(title: Text(item['item_name']), subtitle: Text(item['outlet_name']),);
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
                                  SizedBox(width: 100, child: Text("Request oleh", style: TextStyle(fontWeight: FontWeight.bold),)),
                                  Text(": ${item['request_name']}", style: TextStyle(fontWeight: FontWeight.bold),),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 100, child: Text("Tanggal", style: TextStyle(fontWeight: FontWeight.bold),)),
                                  Text(": ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(item['request_date']))}", style: TextStyle(fontWeight: FontWeight.bold),),
                                ],
                              ),
                              item['started_date'] != null ?
                              Row(
                                children: [
                                  SizedBox(width: 100, child: Text("Dikerjakan", style: TextStyle(fontWeight: FontWeight.bold),)),
                                  Text(": ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(item['started_date']))}", style: TextStyle(fontWeight: FontWeight.bold),),
                                ],
                              ): SizedBox(),
                        
                              const SizedBox(height: 12),
                        
                              // === Tombol aksi ===
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  item['started_date'] != null ?
                                  FilledButton.icon(
                                    onPressed: null,
                                    icon: const Icon(Icons.check),
                                    label: const Text("Kerjakan"),
                                  ):
                                  FilledButton.icon(
                                    onPressed: () => controller.dialogJob(item),
                                    icon: const Icon(Icons.check),
                                    label: const Text("Kerjakan"),
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
