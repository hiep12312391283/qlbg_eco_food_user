import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qlbh_eco_food/features/register/model/user.dart';

class ProfileController extends GetxController {
  // Các controller TextEditingController
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  var isLoading = false.obs; // Trạng thái loading
  late UserModel user; // Thông tin người dùng

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();
    loadUserData(); // Tải thông tin người dùng khi controller được khởi tạo
  }

  // Hàm tải dữ liệu người dùng từ Firestore
  Future<void> loadUserData() async {
    isLoading.value = true;
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (docSnapshot.exists) {
        user = UserModel.fromFirestore(docSnapshot);
        nameController.text = user.name;
        phoneController.text = user.phone;
        addressController.text = user.address;
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể tải thông tin người dùng: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Hàm cập nhật thông tin người dùng
  Future<void> updateUser() async {
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty) {
      Get.snackbar("Lỗi", "Vui lòng điền đầy đủ thông tin.");
      return;
    }

    try {
      isLoading.value = true;
      UserModel updatedUser = UserModel(
        id: user.id,
        email: user.email, // Email không thay đổi
        phone: phoneController.text,
        name: nameController.text,
        address: addressController.text,
      );

      // Cập nhật dữ liệu lên Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .update(updatedUser.toJson());

      Get.snackbar(
          "Cập nhật thành công", "Thông tin cá nhân đã được cập nhật!");
    } catch (e) {
      Get.snackbar("Lỗi", "Có lỗi xảy ra khi cập nhật thông tin: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
