import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlbh_eco_food/base/const/colors.dart';
import 'package:qlbh_eco_food/features/home/models/product_models.dart';

import 'package:intl/intl.dart';

class ProductDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Lấy sản phẩm từ tham số truyền vào
    final Product product = Get.arguments;

    // Định dạng số tiền với dấu phẩy nhưng chỉ thêm .00 khi cần thiết
    String formatPrice(double price) {
      var formatter = NumberFormat("#,###");
      if (price == price.truncateToDouble()) {
        return formatter.format(price);
      } else {
        formatter = NumberFormat("#,###.00");
        return formatter.format(price);
      }
    }

    final formattedPrice = formatPrice(product.price);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: AppColors.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            product.imageBase64.isNotEmpty
                ? Container(
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: MemoryImage(base64Decode(product.imageBase64)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Icon(Icons.image_not_supported, size: 200),
            SizedBox(height: 16),
            Text(
              product.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '$formattedPrice VND',
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
          ],
        ),
      ),
    );
  }
}
