import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qlbh_eco_food/base/const/app_text_style.dart';
import 'package:qlbh_eco_food/base/const/colors.dart';
import 'package:qlbh_eco_food/features/order/controller/order_controller.dart';
import 'package:qlbh_eco_food/features/order/view/order_detail_page.dart';
import 'package:qlbh_eco_food/features/order_history/view/order_history_page.dart'; // Import màn OrderHistoryPage

class OrderPage extends StatelessWidget {
  final OrderController orderController = Get.put(OrderController());

  OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Đơn hàng',
          style: AppTextStyle.font24Semi.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.green.shade400,
        actions: [
          IconButton(
            icon: Icon(Icons.history, color: Colors.white),
            onPressed: () {
              Get.to(
                  () => OrderHistoryPage()); // Chuyển đến màn OrderHistoryPage
            },
          ),
        ],
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
          final ongoingOrders = orderController.orders
              .where((order) => order.orderStatus != 3)
              .toList(); // Lọc các đơn hàng chưa hoàn thành

          if (orderController.isLoading.value) {
            return Center(
                child: CircularProgressIndicator()); // Hiển thị loading
          }
          if (ongoingOrders.isEmpty) {
            return Center(
              child:
                  Text('Chưa có đơn hàng nào.', style: AppTextStyle.font16Re),
            );
          }
          return ListView.builder(
            itemCount: ongoingOrders.length,
            itemBuilder: (context, index) {
              final order = ongoingOrders[index];
              return GestureDetector(
                onTap: () {
                  print("-------${order.orderStatus}");
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
                        Center(
                          child: Text(
                            '${_getStatusText(order.orderStatus)}',
                            style: AppTextStyle.font20Semi,
                          ),
                        ),
                        SizedBox(height: 8),
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
                            Icon(
                                order.paymentMethod == 1
                                    ? Icons.money
                                    : Icons.credit_card,
                                color: Colors.purple),
                            SizedBox(width: 8),
                            Text(
                                'Phương thức thanh toán: ${order.paymentMethod == 1 ? 'Tiền mặt' : 'Online'}',
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

  // Phương thức lấy text cho trạng thái đơn hàng
  String _getStatusText(int status) {
    List<String> statusList = [
      'Đã đặt hàng',
      'Đang chờ đơn vị vận chuyển',
      'Đang vận chuyển',
      'Đơn hàng đã được giao'
    ];
    return statusList[status];
  }
}
