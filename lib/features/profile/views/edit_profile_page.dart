import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlbh_eco_food/features/profile/controller/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin cá nhân'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: controller.nameController,
                  decoration: InputDecoration(labelText: 'Tên'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tên không thể trống';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: controller.phoneController,
                  decoration: InputDecoration(labelText: 'Số điện thoại'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Số điện thoại không thể trống';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: controller.addressController,
                  decoration: InputDecoration(labelText: 'Địa chỉ'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Địa chỉ không thể trống';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: controller.updateUser,
                  child: Text('Cập nhật thông tin'),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
