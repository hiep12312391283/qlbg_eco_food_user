import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlbh_eco_food/base/const/colors.dart';
import 'package:qlbh_eco_food/features/home/models/product_models.dart';
import 'package:qlbh_eco_food/features/product_detail/controller/product_detail_controller.dart';

class ProductDetailPage extends GetView<ProductDetailController> {
  final ProductDetailController controller = Get.put(ProductDetailController());

  @override
  Widget build(BuildContext context) {
    final Product? product = Get.arguments as Product?;

    if (product == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Lỗi'),
        ),
        body: Center(
          child: Text('Lỗi: Không tìm thấy sản phẩm.'),
        ),
      );
    }

    controller.loadComments(product.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: AppColors.backgroundColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: MemoryImage(base64Decode(product.imageBase64)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              product.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '${formatPrice(product.price)} VND',
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
            SizedBox(height: 8),
            Text(
              'Số lượng còn trong kho: ${product.stock}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Mô tả:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              product.description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 8),
            Text(
              'Bình luận:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Obx(() {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: controller.comments.length,
                itemBuilder: (context, index) {
                  final comment = controller.comments[index];
                  return ListTile(
                    title: Text(comment.userName),
                    subtitle: Text(comment.content),
                  );
                },
              );
            }),
            SizedBox(height: 16),
            TextField(
              controller: controller.commentController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nhập bình luận của bạn...',
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                controller.addComment(product.id);
              },
              child: Text(
                'Gửi',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.green),
            ),
          ],
        ),
      ),
    );
  }

  String formatPrice(double price) {
    var formatter = NumberFormat("#,###");
    if (price == price.truncateToDouble()) {
      return formatter.format(price);
    } else {
      formatter = NumberFormat("#,###.00");
      return formatter.format(price);
    }
  }
}
