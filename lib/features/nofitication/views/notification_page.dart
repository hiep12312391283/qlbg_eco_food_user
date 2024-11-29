import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlbh_eco_food/base/const/app_text_style.dart';
import 'package:qlbh_eco_food/base/const/colors.dart';
import 'package:qlbh_eco_food/base/widget/base_widget.dart';
import 'package:qlbh_eco_food/features/nofitication/controller/notification_controller.dart';

class NotificationPage extends GetView<NotificationController> {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
          child: Column(
        children: [
          // Container(
          //   height: 50,
          //   width: double.infinity,
          //   decoration: const BoxDecoration(color: Colors.white),
          //   child: BaseWidget.buildText(
          //     "Thông báo",
          //     style: AppTextStyle.font24Re,
          //   ),
          // ),
        ],
      )),
    );
  }
}
