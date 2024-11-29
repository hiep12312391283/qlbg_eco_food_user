import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlbh_eco_food/base/const/app_text_style.dart';
import 'package:qlbh_eco_food/base/const/colors.dart';
import 'package:qlbh_eco_food/features/home/controller/home_controller.dart';
import 'package:qlbh_eco_food/features/cart/controller/cart_controller.dart';
import 'package:intl/intl.dart';
import 'package:qlbh_eco_food/features/home/models/product_models.dart';

class HomePage extends GetView<HomeController> {
  HomePage({super.key});
  @override
  final HomeController controller = Get.put(HomeController());
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: controller.products.length,
                itemBuilder: (context, index) {
                  final product = controller.products[index];

                  // Định dạng giá tiền với dấu phẩy giữa các hàng ngàn
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

                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    elevation: 3,
                    child: InkWell(
                      onTap: () {
                        Get.toNamed('/product_detail', arguments: product);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            product.imageBase64.isNotEmpty
                                ? Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: MemoryImage(
                                            base64Decode(product.imageBase64)),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : Icon(Icons.image_not_supported, size: 50),
                            SizedBox(width: 16),
                            // Hiển thị tên sản phẩm và giá tiền
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '$formattedPrice VND',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Nút thêm vào giỏ hàng
                            IconButton(
                              icon: Icon(Icons.add_shopping_cart,
                                  color: AppColors.green),
                              onPressed: () {
                                _showBottomSheet(
                                    context, product, cartController);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(
      BuildContext context, Product product, CartController cartController) {
    RxInt quantity = 1.obs;
    RxDouble subtotal = product.price.obs;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  product.imageBase64.isNotEmpty
                      ? Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: MemoryImage(
                                  base64Decode(product.imageBase64)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Icon(Icons.image_not_supported, size: 50),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${formatPrice(product.price)} VND',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Còn lại: ${product.stock}', // Hiển thị số lượng trong kho
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Số lượng',
                    style: TextStyle(fontSize: 16),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          if (quantity.value > 1) {
                            quantity.value--;
                            subtotal.value = product.price * quantity.value;
                          }
                        },
                      ),
                      Obx(() => Text(
                            '${quantity.value}',
                            style: TextStyle(fontSize: 16),
                          )),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          if (quantity.value < product.stock) {
                            quantity.value++;
                            subtotal.value = product.price * quantity.value;
                          } else {
                            Get.snackbar('Thông báo', 'Không đủ hàng trong kho',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                colorText: Colors.white);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tạm tính',
                    style: TextStyle(fontSize: 16),
                  ),
                  Obx(() => Text(
                        '${formatPrice(subtotal.value)} VND',
                        style: TextStyle(fontSize: 16),
                      )),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (quantity.value <= product.stock) {
                    cartController.addToCart(product, quantity.value);
                    Navigator.pop(context);
                  } else {
                    Get.snackbar('Thông báo', 'Không đủ hàng trong kho',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white);
                  }
                },
                child: Text('Thêm vào giỏ hàng'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 40),
                ),
              ),
            ],
          ),
        );
      },
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
