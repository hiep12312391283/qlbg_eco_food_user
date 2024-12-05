import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  var validateMode = AutovalidateMode.disabled.obs;
  var isObscure = true.obs;
  var isLoading = false.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void toggleEyeIcon() {
    isObscure.value = !isObscure.value;
  }

  
}
