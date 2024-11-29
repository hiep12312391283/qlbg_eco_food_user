import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlbh_eco_food/base/const/colors.dart';
import 'package:qlbh_eco_food/features/cart/controller/cart_controller.dart';
import 'package:intl/intl.dart';
import 'package:qlbh_eco_food/features/payment/view/payment_view.dart';

class CartPage extends GetView<CartController> {
  CartPage({super.key});
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giỏ hàng'),
        centerTitle: true,
        backgroundColor: AppColors.backgroundColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (cartController.cartItems.isEmpty) {
                return Center(child: Text('Giỏ hàng của bạn đang trống'));
              }
              return ListView.builder(
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final cartItem = cartController.cartItems[index];
                  String formatPrice(double price) {
                    var formatter = NumberFormat("#,###");
                    if (price == price.truncateToDouble()) {
                      return formatter.format(price);
                    } else {
                      formatter = NumberFormat("#,###.00");
                      return formatter.format(price);
                    }
                  }

                  final formattedPrice =
                      formatPrice(cartItem.product.price * cartItem.quantity);

                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    elevation: 3,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          // Hiển thị ảnh sản phẩm
                          cartItem.product.imageBase64.isNotEmpty
                              ? Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: MemoryImage(base64Decode(
                                          cartItem.product.imageBase64)),
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
                                  cartItem.product.name,
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
                                SizedBox(height: 4),
                                // Hiển thị số lượng
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove),
                                      onPressed: () {
                                        if (cartItem.quantity > 1) {
                                          cartController.updateQuantity(
                                              cartItem.product,
                                              cartItem.quantity - 1);
                                        }
                                      },
                                    ),
                                    Text(
                                      '${cartItem.quantity}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        cartController.updateQuantity(
                                            cartItem.product,
                                            cartItem.quantity + 1);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Nút xóa sản phẩm
                          IconButton(
                            icon: Icon(Icons.remove_circle, color: Colors.red),
                            onPressed: () {
                              cartController.removeFromCart(cartItem.product);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          // Divider(height: 1),
          Obx(() {
            // Định dạng tổng giá tiền
            String formatTotalPrice(double price) {
              var formatter = NumberFormat("#,###");
              if (price == price.truncateToDouble()) {
                return formatter.format(price);
              } else {
                formatter = NumberFormat("#,###.00");
                return formatter.format(price);
              }
            }

            final formattedTotalPrice =
                formatTotalPrice(cartController.totalPrice.value);

            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tổng cộng:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$formattedTotalPrice VND',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.to(PaymentPage());
              },
              child: Text('Thanh toán'),
            ),
          ).paddingAll(16)
        ],
      ),
    );
  }
}
