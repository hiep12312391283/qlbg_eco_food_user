import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qlbh_eco_food/app/ui/custom/custom_button.dart';
import 'package:qlbh_eco_food/auth/auth_service.dart';
import 'package:qlbh_eco_food/base/const/app_text_style.dart';
import 'package:qlbh_eco_food/base/const/colors.dart';
import 'package:qlbh_eco_food/base/widget/base_widget.dart';
import 'package:qlbh_eco_food/features/login/controller/login_controller.dart';

class LoginPage extends GetView<LoginController> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final void Function()? onTap;
  LoginPage({super.key, required this.onTap});

  void login(BuildContext context) async {
    final authService = AuthService();
    try {
      User? user = await authService.signInWithEmailPassword(
          _emailController.text, _passwordController.text);

      if (user != null && user.emailVerified) {
        Get.offAllNamed('/home_page');
      } else {
        // await authService.signOut();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Email chưa được xác thực"),
            content: Text(
                "Vui lòng kiểm tra email của bạn để xác thực tài khoản trước khi đăng nhập."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Hiển thị thông báo lỗi nếu đăng nhập thất bại
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Đăng nhập thất bại"),
                // content: Text(e.toString()),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Form(
              autovalidateMode: controller.validateMode.value,
              child: SingleChildScrollView(
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: SvgPicture.asset(
                          'assets/image/logo.svg',
                          width: 200,
                          height: 200,
                        ),
                      ).paddingOnly(top: 30),
                      const SizedBox(height: 20),
                      txtFormField(
                        controller: _emailController,
                        text: "Email",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Vui lòng nhập email";
                          }
                          return null;
                        },
                      ).paddingOnly(bottom: 16),
                      txtFormField(
                        controller: _passwordController,
                        text: "Mật khẩu",
                        validator: (value) {
                          if (value == null ||
                              value.length < 8 ||
                              value.isEmpty) {
                            return "Mật khẩu phải lớn hơn 8 ký tự";
                          }
                          return null;
                        },
                      ).paddingOnly(bottom: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                            onTap: () {
                              Get.toNamed('/forgot-password');
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: BaseWidget.buildText("Quên mật khẩu?",
                                style: AppTextStyle.font16Re.copyWith(
                                  color: AppColors.green,
                                ))),
                      ).paddingOnly(bottom: 8),
                      CustomButton(
                        textBtn: 'Đăng nhập',
                        onPressed: () {
                          login(context);
                        },
                      ).paddingOnly(bottom: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Chưa có tài khoản?",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Oswald',
                            ),
                          ).paddingOnly(right: 4),
                          InkWell(
                            onTap: () {
                              Get.toNamed('/register');
                            },
                            child: const Text(
                              "Đăng ký",
                              style: TextStyle(
                                color: Color(0xFF83C167),
                                fontSize: 16,
                                fontFamily: 'Oswald',
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 16),
                ),
              ),
            ),
          ],
        ));
  }
}

Widget txtFormField({
  required String text,
  required TextEditingController controller,
  required FormFieldValidator<String> validator,
  TextStyle? style,
  int? maxLength,
  TextInputType? textInputType,
  List<TextInputFormatter>? inputFormatters,
}) {
  return Column(
    children: [
      Align(
        alignment: Alignment.centerLeft,
        child: Text(text, style: AppTextStyle.font16Re),
      ).paddingOnly(bottom: 8),
      TextFormField(
        controller: controller,
        style: style ??
            AppTextStyle.font14Re.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
        maxLength: maxLength,
        keyboardType: textInputType,
        inputFormatters: inputFormatters,
        validator: validator,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          counterText: "",
          hintText: text,
          hintStyle: style,
          filled: true,
          fillColor: AppColors.txtFormField,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide.none),
        ),
      ),
    ],
  );
}
