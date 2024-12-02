import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final validateMode = AutovalidateMode.disabled.obs;
  final formKey = GlobalKey<FormState>();
  final RxBool isObscure = true.obs;
  final RxBool isLoading = false.obs;
  final RxString password = ''.obs;

  Future<void> login() async {}
  void toggleEyeIcon() {
    isObscure.value = !isObscure.value;
  }

  void setPassword(String passWordChanged) {
    password.value = passWordChanged;
  }


}
