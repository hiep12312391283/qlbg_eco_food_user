import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import gói intl
import 'package:qlbh_eco_food/base/const/app_text_style.dart';
import 'package:qlbh_eco_food/features/order/controller/order_controller.dart';
import 'package:qlbh_eco_food/features/payment/model/order_model.dart';

class OrderDetailPage extends GetView<OrderController> {
  final OrderAdmin order;
  final OrderController orderController = Get.put(OrderController());
  OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Chi tiết đơn hàng',
            style: AppTextStyle.font24Semi.copyWith(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hiển thị trạng thái đơn hàng
                    Obx(
                      () {
                        // Lệnh in ra log kiểm tra
                        final orderDetail = orderController.orders.firstWhere(
                            (o) => o.documentId == order.documentId);
                        print(
                            'Order ID: ${orderDetail.documentId}, Order Status from controller: ${orderDetail.orderStatus}');
                        return _buildOrderStatus(orderDetail.orderStatus);
                      },
                    ),
                    // Hiển thị các thông tin chi tiết của đơn hàng
                    _buildDetailRow(
                      title: 'ID đơn hàng',
                      value: order.documentId.toString().toUpperCase().trim(),
                      icon: Icons.receipt_long,
                    ),
                    _buildDetailRow(
                      title: 'Địa chỉ giao hàng',
                      value: order.userAddress,
                      icon: Icons.location_on,
                    ),
                    _buildDetailRow(
                      title: 'Ngày đặt hàng',
                      value: _formatDateTime(order.orderDate),
                      icon: Icons.date_range,
                    ),
                    _buildDetailRow(
                      title: 'Tổng tiền thanh toán',
                      value: _formatCurrency(order.totalPrice),
                      icon: Icons.monetization_on,
                    ),
                    _buildDetailRow(
                      title: 'Phương thức thanh toán',
                      value: order.paymentMethod == 1 ? 'Tiền mặt' : 'Online',
                      icon: order.paymentMethod == 1
                          ? Icons.money
                          : Icons.credit_card,
                    ),
                    const SizedBox(height: 20),
                    // Hiển thị thông tin sản phẩm trong đơn hàng
                    Text('Sản phẩm:', style: AppTextStyle.font16Semi),
                    SizedBox(height: 10),
                    ...order.products
                        .map((item) => _buildProductRow(item))
                        .toList(),
                  ],
                ),
              ),
            ),
            // Thêm nút Hủy đơn hàng nếu trạng thái là Đã đặt hàng
            Obx(
              () {
                if (orderController.orders
                        .firstWhere((o) => o.documentId == order.documentId)
                        .orderStatus ==
                    0) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _showCancelOrderDialog(context);
                      },
                      child: Text('Hủy đơn hàng'),
                    ),
                  );
                } else {
                  return Container(); // Trả về container rỗng nếu không cần hiển thị nút
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Hiển thị dialog xác nhận hủy đơn hàng
  void _showCancelOrderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận hủy đơn hàng'),
          content: Text('Bạn có chắc chắn muốn hủy đơn hàng này không?'),
          actions: <Widget>[
            TextButton(
              child: Text('Không'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Có'),
              onPressed: () {
                orderController.deleteOrder(order.documentId!);
                Get.offNamedUntil('/home_page', (route) => route.isFirst,
                    arguments: 2);
              },
            ),
          ],
        );
      },
    );
  }

  // Xây dựng phần hiển thị thông tin chi tiết của đơn hàng
  Widget _buildDetailRow({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          SizedBox(width: 10),
          Text('$title:', style: AppTextStyle.font16Semi),
          SizedBox(width: 10),
          Flexible(
            child: Text(
              value,
              style: AppTextStyle.font16Re,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Hiển thị thông tin sản phẩm trong đơn hàng
  Widget _buildProductRow(OrderItemAdmin item) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          item.imageBase64.isNotEmpty
              ? Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: MemoryImage(base64Decode(item.imageBase64)),
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
                  item.productName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  _formatCurrency(item.price), // Định dạng giá tiền
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Số lượng: ${item.quantity}',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Xây dựng phần trạng thái đơn hàng
  Widget _buildOrderStatus(int status) {
    List<String> statusList = [
      'Đã đặt hàng',
      'Đang chờ đơn vị vận chuyển',
      'Đang vận chuyển',
      'Đơn hàng đã được giao'
    ];

    print('Displaying Order Status in UI: $status'); // Thêm lệnh in ra log

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Trạng thái đơn hàng:', style: AppTextStyle.font16Semi),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(statusList.length, (index) {
            return Expanded(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor:
                        index <= status ? Colors.green : Colors.grey,
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(statusList[index],
                      style: AppTextStyle.font12Re,
                      textAlign: TextAlign.center),
                ],
              ),
            );
          }),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  // Định dạng giá tiền
  String _formatCurrency(double amount) {
    final formatCurrency =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'VND');
    return formatCurrency.format(amount);
  }

  // Định dạng ngày giờ
  String _formatDateTime(DateTime dateTime) {
    final formatDateTime = DateFormat('dd/MM/yyyy HH:mm');
    return formatDateTime.format(dateTime);
  }
}
