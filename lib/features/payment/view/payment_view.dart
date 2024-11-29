import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlbh_eco_food/features/payment/controller/payment_controller.dart';
import 'package:qlbh_eco_food/base/const/app_text_style.dart';
import 'package:qlbh_eco_food/base/const/colors.dart';
import 'package:intl/intl.dart';
import 'package:qlbh_eco_food/features/payment/view/confirm_payment_view.dart';
import 'package:qlbh_eco_food/features/register/controller/register_controller.dart';
import 'package:qlbh_eco_food/features/cart/controller/cart_controller.dart'; // Import CartController

class PaymentPage extends StatelessWidget {
  final RegisterController registerController = Get.put(RegisterController());
  final PaymentController paymentController = Get.put(PaymentController());
  final CartController cartController = Get.put(CartController());

  PaymentPage({super.key}); // Create an instance of CartController

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Thanh toán', style: AppTextStyle.font24Semi),
        backgroundColor: AppColors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Thông tin khách hàng', style: AppTextStyle.font20Semi),
            SizedBox(height: 10),
            Obx(() => Text('Họ và tên: ${paymentController.userName}',
                style: AppTextStyle.font16Re)),
            Obx(() => Text('Số điện thoại: ${paymentController.userPhone}',
                style: AppTextStyle.font16Re)),
            Obx(() => Text('Địa chỉ: ${paymentController.userAddress}',
                style: AppTextStyle.font16Re)),
            SizedBox(height: 20),
            Text('Giỏ hàng', style: AppTextStyle.font20Semi),
            Expanded(
              child: Obx(() {
                if (cartController.cartItems.isEmpty) {
                  return Center(child: Text('Giỏ hàng của bạn đang trống'));
                }
                return ListView.builder(
                  itemCount: cartController.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartController.cartItems[index];

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
                        formatPrice(item.product.price * item.quantity);

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      elevation: 3,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            item.product.imageBase64.isNotEmpty
                                ? Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: MemoryImage(base64Decode(
                                            item.product.imageBase64)),
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
                                    item.product.name,
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
                                  Text(
                                    'Số lượng: ${item.quantity}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
            SizedBox(height: 10),
            Text('Phương thức thanh toán', style: AppTextStyle.font20Semi),
            Obx(() => Column(
                  children: [
                    RadioListTile<int>(
                      title: const Text('Thanh toán bằng tiền mặt'),
                      value: 1,
                      groupValue: paymentController.paymentMethod.value,
                      onChanged: (value) {
                        paymentController.paymentMethod.value = value!;
                      },
                    ),
                    RadioListTile<int>(
                      title: const Text('Thanh toán online'),
                      value: 2,
                      groupValue: paymentController.paymentMethod.value,
                      onChanged: (value) {
                        paymentController.paymentMethod.value = value!;
                      },
                    ),
                    Row(
                      children: [
                        Icon(Icons.local_shipping, color: Colors.green),
                        SizedBox(width: 8),
                        Text('Dự kiến giao hàng hôm nay, 15:00-18:00',
                            style: AppTextStyle.font16Re),
                      ],
                    ),
                  ],
                )),
            SizedBox(height: 20),
            Obx(() => Text(
                  'Tổng tiền: ${formatPrice(cartController.totalPrice.value)} VND',
                  style: AppTextStyle.font18Semi,
                )),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showConfirmationDialog(context);
                },
                child: Text('Đặt hàng'),
              ),
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

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận đặt hàng'),
          content: Text('Bạn có chắc chắn muốn đặt hàng không?'),
          actions: [
            TextButton(
              child: Text('Không'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Có'),
              onPressed: () {
                Navigator.of(context).pop();
                paymentController.placeOrder();
                _showSuccessPage(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showSuccessPage(BuildContext context) {
    Get.to(() => PaymentSuccessPage());
  }
}
