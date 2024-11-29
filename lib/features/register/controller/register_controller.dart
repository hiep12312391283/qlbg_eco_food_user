import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qlbh_eco_food/auth/auth_service.dart';
import 'package:qlbh_eco_food/features/register/model/user.dart';

class RegisterController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  var users = <UserModel>[].obs;
  final formKey = GlobalKey<FormState>();

  final isLoading = false.obs; // Trạng thái loading

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Phương thức để đăng ký và thêm người dùng vào Firestore
  Future<void> validateAndAddUser(BuildContext context) async {
    print("Bắt đầu validateAndAddUser");
    if (passwordController.text == confirmPasswordController.text) {
      try {
        print("Bắt đầu đăng ký tài khoản");
        final authService = AuthService();
        await authService.signUpWithEmailPassword(
            emailController.text, passwordController.text);
        print("Đăng ký thành công với email: ${emailController.text}");

        // Gửi email xác nhận
        FirebaseAuth.instance.currentUser?.sendEmailVerification();

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Xác nhận email"),
            content: Text(
                "Một email xác nhận đã được gửi tới ${emailController.text}. Vui lòng kiểm tra hộp thư của bạn để xác nhận."),
            actions: [
              TextButton(
                onPressed: () async {
                  Get.toNamed('/login');
                  await checkEmailVerification(context);
                },
                child: Text("OK"),
              ),
            ],
          ),
        );
      } catch (e) {
        print("Lỗi khi đăng ký: $e");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Đăng ký thất bại"),
            content: Text(e.toString()),
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Mật khẩu không giống nhau"),
        ),
      );
    }
  }

  // Kiểm tra trạng thái xác nhận email của người dùng
  Future<void> checkEmailVerification(BuildContext context) async {
    bool emailVerified = false;

    // Kiểm tra trạng thái xác thực email liên tục
    while (!emailVerified) {
      await FirebaseAuth.instance.currentUser?.reload();
      emailVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;

      if (emailVerified) {
        // Sau khi email được xác thực, đẩy dữ liệu người dùng lên Firestore và Realtime Database
        UserModel user = UserModel(
          id: FirebaseAuth.instance.currentUser!.uid,
          email: emailController.text,
          phone: phoneController.text,
          name: nameController.text,
          address: addressController.text,
        );

        addUser(user); // Thêm người dùng vào Firestore và Realtime Database
        print("Lưu thông tin người dùng thành công");

        Get.toNamed('/login');
        break;
      } else {
        print("Email chưa được xác thực, thử lại...");
        // Đợi một khoảng thời gian (ví dụ 3 giây) trước khi kiểm tra lại
        await Future.delayed(Duration(seconds: 3));
      }
    }
  }

  // Thêm thông tin người dùng vào Firestore và Realtime Database
  void addUser(UserModel user) {
    // Thêm vào Firestore
    _firestore
        .collection('users')
        .doc(user.id)
        .set(user.toJson())
        .catchError((e) {
      print("Lỗi khi thêm vào Firestore: $e");
    });

    // Thêm vào Realtime Database
    _database
        .ref()
        .child('users')
        .child(user.id)
        .set(user.toJson())
        .catchError((e) {
      print("Lỗi khi thêm vào Realtime Database: $e");
    });
  }
}
