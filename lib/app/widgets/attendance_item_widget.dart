import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snpos/app/utils/currency_formatter.dart';

class AttendanceItemWidget extends GetView {
  const AttendanceItemWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 55,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tanggulangin', style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text('Masuk : 14/02/2023 06.53', style: Get.textTheme.labelSmall),
                SizedBox(height: 5),
                Text('Keluar : 14/02/2023 06.53', style: Get.textTheme.labelSmall)
              ],
            ),
          ),
          Expanded(
            flex: 45,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(color: Get.theme.primaryColor, borderRadius: BorderRadius.circular(7.5)),
                        child: Text('Shift', style: TextStyle(color: Colors.white))
                    ),
                    SizedBox(width: 10),
                    Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(color: Color(0xff009E00), borderRadius: BorderRadius.circular(7.5)),
                        child: Text('Tepat Waktu', style: TextStyle(color: Colors.white))
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(color: Get.theme.primaryColor, borderRadius: BorderRadius.circular(7.5)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Omset : ${CurrencyFormatter.toRupiah(34543545)}', style: Get.textTheme.labelSmall?.copyWith(color: Colors.white)),
                        Text('Belum Setor', style: Get.textTheme.labelSmall?.copyWith(color: Colors.white)),
                      ]
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}