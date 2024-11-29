import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:qlbh_eco_food/app/ui/custom/custom_button.dart';
import 'package:qlbh_eco_food/base/const/app_text_style.dart';
import 'package:qlbh_eco_food/base/const/colors.dart';
import 'package:qlbh_eco_food/base/widget/base_widget.dart';
import 'package:qlbh_eco_food/features/register/controller/register_controller.dart';

class RegisterPage extends StatelessWidget {
  final RegisterController controller = Get.put(RegisterController());
  final Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: BaseWidget.buildText(
          "Đăng ký",
          style: AppTextStyle.font24Semi,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                txtFormField(
                    text: "Họ và tên", controller: controller.nameController),
                txtFormField(
                    text: "Email", controller: controller.emailController),
                txtFormField(
                    text: "Số điện thoại",
                    controller: controller.phoneController),
                txtFormField(
                    text: "Địa chỉ giao hàng",
                    controller:
                        controller.addressController), // Thêm ô nhập địa chỉ
                txtFormField(
                    text: "Mật khẩu",
                    controller: controller.passwordController),
                txtFormField(
                    text: "Xác nhận mật khẩu",
                    controller: controller.confirmPasswordController),
                CustomButton(
                  textBtn: 'Đăng Ký',
                  onPressed: () {
                    controller.validateAndAddUser(context);
                  },
                ).paddingOnly(bottom: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Nếu bạn đã có tài khoản?",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Oswald',
                      ),
                    ).paddingOnly(right: 4),
                    InkWell(
                      onTap: () {
                        Get.toNamed('/login');
                      },
                      child: BaseWidget.buildText(
                        "Đăng nhập",
                        style: AppTextStyle.font16Re
                            .copyWith(color: AppColors.green),
                      ),
                    ),
                  ],
                ),
              ],
            ).paddingSymmetric(horizontal: 16).paddingOnly(bottom: 16),
          ),
        ),
      ),
    );
  }
}

Widget txtFormField({
  TextEditingController? controller,
  required String text,
}) {
  return Column(
    children: [
      Align(
        alignment: Alignment.centerLeft,
        child: BaseWidget.buildText(
          text,
          style: AppTextStyle.font16Re,
        ),
      ).paddingOnly(bottom: 8),
      SizedBox(
        height: 44,
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: text,
            hintStyle: const TextStyle(fontFamily: 'Oswald', fontSize: 14),
            filled: true,
            fillColor: const Color(0xFFF3E9B5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    ],
  ).paddingOnly(bottom: 16);
}
