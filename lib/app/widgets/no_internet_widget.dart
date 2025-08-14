import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoInternetWidget extends GetView {
  const NoInternetWidget({super.key, required this.onClickRefresh, this.errorMessage});
  final Function onClickRefresh;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/images/no-internet.png', scale: 2,),
        errorMessage != null ?
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(15), color: Color(0xffDCDCDC)),
          child: Text(errorMessage!),
        ) : SizedBox(),
        SizedBox(width: Get.width, child: FilledButton(onPressed: () => onClickRefresh(), child: Text('Refresh')),)
      ],
    );
  }
}
