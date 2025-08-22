import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:snpos/app/routes/app_pages.dart';
import 'package:snpos/app/widgets/no_internet_widget.dart';

import '../controllers/item_requests_controller.dart';

class ItemRequestsView extends GetView<ItemRequestsController> {
  const ItemRequestsView({super.key});
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
      floatingActionButton: FilledButton.icon(
        onPressed: () async {
          await Get.toNamed(Routes.FORM_ITEM_REQUEST);
          controller.fetchRequests();
        },
        label: Text('Request Barang'),
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
                children: [NoInternetWidget(onClickRefresh  : () => controller.fetchRequests(), errorMessage: controller.state['message'])],
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

            return ListView.builder(
              itemCount: controller.requests.length,

              itemBuilder: (context, index) {
                var request = controller.requests[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getStatusColor(request['status']).withOpacity(0.2),
                    child: Icon(_getStatusIcon(request['status']), color: _getStatusColor(request['status'])),
                  ),
                  title: Text("${request['item_name']} x${request['qty']}"),
                  subtitle: Text("Outlet: ${request['outlet_name']}"),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(request['status']).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _getStatusColor(request['status'])),
                    ),
                    child: Text(
                      request['status'],
                      style: TextStyle(
                        color: _getStatusColor(request['status']),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }
            );

          }),
        ),
      ),
    );
  }

  Color _getStatusColor(status) {
    switch (status) {
      case 'APPROVED':
        return Colors.blue;
      case 'ACCEPTED':
        return Colors.green;
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
      default:
        return Icons.hourglass_bottom;
    }
  }

}
