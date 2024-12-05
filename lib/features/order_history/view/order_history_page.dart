import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qlbh_eco_food/base/const/app_text_style.dart';
import 'package:qlbh_eco_food/base/const/colors.dart';
import 'package:qlbh_eco_food/features/order/controller/order_controller.dart';
import 'package:qlbh_eco_food/features/order/view/order_detail_page.dart';

class OrderHistoryPage extends StatelessWidget {
  final OrderController orderController = Get.put(OrderController());

  OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Lịch sử đơn hàng',
          style: AppTextStyle.font24Semi.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.green.shade400,
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.green.shade100, AppColors.green.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Obx(() {
          final completedOrders = orderController.orders
              .where((order) => order.orderStatus == 3)
              .toList();

          if (completedOrders.isEmpty) {
            return Center(
              child: Text('Chưa có đơn hàng hoàn thành.',
                  style: AppTextStyle.font16Re),
            );
          }

          return ListView.builder(
            itemCount: completedOrders.length,
            itemBuilder: (context, index) {
              final order = completedOrders[index];
              return GestureDetector(
                onTap: () {
                  Get.to(() => OrderDetailPage(order: order));
                },
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  elevation: 3,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.receipt_long, color: Colors.green),
                            SizedBox(width: 8),
                            Text(
                                'Mã đơn hàng: ${order.documentId.toString().toUpperCase()}',
                                style: AppTextStyle.font16Re),
                          ],
                        ),
                        SizedBox(height: 8),
                        // Row(
                        //   children: [
                        //     Icon(Icons.person, color: Colors.blue),
                        //     SizedBox(width: 8),
                        //     Text('Khách hàng: ${order.userName}',
                        //         style: AppTextStyle.font16Re),
                        //   ],
                        // ),
                        // SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Địa chỉ giao hàng: ${order.userAddress}',
                                style: AppTextStyle.font16Re),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.monetization_on, color: Colors.orange),
                            SizedBox(width: 8),
                            Text(
                                'Tổng tiền thanh toán: ${_formatCurrency(order.totalPrice)}',
                                style: AppTextStyle.font16Semi),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.check_circle_outline,
                                color: Colors.green),
                            SizedBox(width: 8),
                            Text('Trạng thái đơn hàng: Đã hoàn thành',
                                style: AppTextStyle.font16Re),
                          ],
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
    );
  }

  // Phương thức định dạng tiền tệ
  String _formatCurrency(double amount) {
    final formatCurrency =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'VND');
    return formatCurrency.format(amount);
  }
}
