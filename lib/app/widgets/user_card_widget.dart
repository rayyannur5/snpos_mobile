import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserCardWidget extends GetView {
  final String name;
  final String position;
  final String shift;
  final String checkIn;
  final String location;
  final String status;

  const UserCardWidget({
    super.key,
    required this.name,
    required this.position,
    required this.shift,
    required this.checkIn,
    required this.location,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Get.theme.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row atas -> Avatar + Nama/Position + Status di kanan
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.blue.shade200,
                  child:
                  const Icon(Icons.person, size: 36, color: Colors.white),
                ),
                const SizedBox(width: 16),

                // Nama + Position
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        position,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // Status chip di kanan
                Chip(
                  avatar: Icon(
                    status == "Tepat Waktu"
                        ? Icons.check_circle
                        : Icons.warning_amber_rounded,
                    size: 18,
                    color: status == "Tepat Waktu"
                        ? Colors.green.shade700
                        : Colors.orange.shade700,
                  ),
                  label: Text(
                    status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: status == "Tepat Waktu"
                          ? Colors.green.shade700
                          : Colors.orange.shade700,
                    ),
                  ),
                  backgroundColor: status == "Tepat Waktu"
                      ? Colors.green.shade100
                      : Colors.orange.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Detail info (Shift, Check-in, Lokasi)
            _buildInfoRow("Shift", shift),
            _buildInfoRow("Check-in", checkIn),
            _buildInfoRow("Outlet", location),
          ],
        ),
      ),
    );
  }

  // fungsi helper biar label & value sejajar
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 100, // lebar tetap untuk label
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
            ),
          ),
          Expanded(
            child: Text(": $value", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
