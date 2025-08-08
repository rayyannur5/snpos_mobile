import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:snpos/app/utils/currency_formatter.dart';

class AttendanceItemWidget extends GetView {
  const AttendanceItemWidget({
    super.key,
    required this.outlet,
    required this.dateIn,
    required this.dateOut,
    required this.shift,
    required this.omset,
    required this.isLate,
    required this.isDeposit,
  });

  final String outlet;
  final DateTime dateIn;
  final DateTime dateOut;
  final String shift;
  final int omset;
  final bool isLate;
  final bool isDeposit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(outlet, style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text('Masuk : ${DateFormat('dd/MM/yyyy HH:mm').format(dateIn)}', style: Get.textTheme.labelSmall),
                SizedBox(height: 5),
                Text('Keluar : ${DateFormat('dd/MM/yyyy HH:mm').format(dateOut)}', style: Get.textTheme.labelSmall)
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(color: Get.theme.primaryColor, borderRadius: BorderRadius.circular(7.5)),
                        child: Text(shift, style: TextStyle(color: Colors.white))
                    ),
                    SizedBox(width: 10),
                    isLate ?
                    Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(color: Color(0xff9e0000), borderRadius: BorderRadius.circular(7.5)),
                        child:  Text('Terlambat', style: TextStyle(color: Colors.white))
                    ) :
                    Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(color: Color(0xff009E00), borderRadius: BorderRadius.circular(7.5)),
                        child:  Text('Tepat Waktu', style: TextStyle(color: Colors.white))
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
                        Text('Omset : ${CurrencyFormatter.toRupiah(omset)}', style: Get.textTheme.labelSmall?.copyWith(color: Colors.white)),
                        Text(isDeposit ? 'Sudah Setor' : 'Belum Setor', style: Get.textTheme.labelSmall?.copyWith(color: Colors.white)),
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