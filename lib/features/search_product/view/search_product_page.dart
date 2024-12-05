import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qlbh_eco_food/base/const/colors.dart';
import 'package:qlbh_eco_food/features/home/controller/home_controller.dart';

class SearchProductPage extends GetView<HomeController> {
  SearchProductPage({super.key});

  @override
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context)
            .unfocus(); // Đóng bàn phím khi người dùng bấm ra ngoài
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: TextField(
            controller: controller.searchController,
            onChanged: (value) {
              controller.updateSearchQuery(value); // Cập nhật truy vấn tìm kiếm
            },
            decoration: InputDecoration(
              hintText: 'Nhập tên sản phẩm',
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.white54),
            ),
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
          backgroundColor: AppColors.green.shade400,
        ),
        body: Obx(() {
          // Lọc danh sách sản phẩm theo tên khi tìm kiếm
          final filteredProducts = controller.products.where((product) {
            return product.name
                .toLowerCase()
                .contains(controller.searchQuery.value.toLowerCase());
          }).toList();

          if (controller.isLoading.value) {
            return Center(
                child:
                    CircularProgressIndicator()); // Hiển thị loading khi dữ liệu đang được tải
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              final product = filteredProducts[index];
              return Card(
                elevation: 2,
                child: ListTile(
                  leading: product.imageBase64.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.memory(
                            base64Decode(product.imageBase64),
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(
                          Icons.image_not_supported,
                          size: 60,
                        ),
                  title: Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mã sản phẩm: ${product.id}'),
                      Text('Loại: ${product.categoryId}'),
                      Text('Giá: ${product.price.toStringAsFixed(2)} VND'),
                      Text('Kho: ${product.stock}'),
                      Text(
                        'Hạn sử dụng: ${DateFormat('dd/MM/yyyy').format(product.expiryDate)}',
                      ),
                    ],
                  ),
                ),
              ).paddingOnly(top: 8);
            },
          );
        }),
      ),
    );
  }
}
