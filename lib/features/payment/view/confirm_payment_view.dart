import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qlbh_eco_food/features/cart/controller/cart_controller.dart';
import 'package:qlbh_eco_food/features/payment/controller/payment_controller.dart';
import 'package:qlbh_eco_food/base/const/app_text_style.dart';

class PaymentSuccessPage extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();
  final PaymentController paymentController = Get.find<PaymentController>();

  PaymentSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(now);

    return Scaffold(
      appBar: AppBar(
        title: Text('Đặt hàng thành công', style: AppTextStyle.font24Semi),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50), // Khoảng cách phía trên
            Icon(Icons.check_circle, color: Colors.green, size: 80),
            SizedBox(height: 20),
            Text('Đặt hàng thành công!', style: AppTextStyle.font20Semi),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ngày đặt hàng: $formattedDate',
                      style: AppTextStyle.font16Re),
                  Text('Tổng cộng sản phẩm: ${cartController.cartItems.length}',
                      style: AppTextStyle.font16Re),
                  Text(
                      'Tổng thanh toán: ${formatPrice(cartController.totalPrice.value)} VND',
                      style: AppTextStyle.font16Re),
                  Text(
                      'Phương thức thanh toán: ${paymentController.paymentMethod.value == 1 ? 'Tiền mặt' : 'Online'}',
                      style: AppTextStyle.font16Re),
                  Row(
                    children: [
                      Icon(Icons.local_shipping, color: Colors.green),
                      SizedBox(width: 8),
                      Text('Dự kiến giao hàng hôm nay, 15:00-18:00',
                          style: AppTextStyle.font16Re),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Xóa giỏ hàng khi người dùng tiếp tục mua sắm
                      cartController.cartItems.clear();
                      Get.offNamed("/home_page");
                    },
                    child: Text('Tiếp tục mua sắm'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Xử lý xem đơn hàng của tôi
                    },
                    child: Text('Đơn hàng của tôi'),
                  ),
                ),
              ],
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
