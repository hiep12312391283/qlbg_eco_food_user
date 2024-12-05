import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qlbh_eco_food/features/nofitication/controller/notification_controller.dart';
import 'package:qlbh_eco_food/features/payment/model/order_model.dart';

class OrderController extends GetxController {
  var orders = <OrderAdmin>[].obs; // Danh sách các đơn hàng
  var isLoading = false.obs; // Trạng thái loading
final NotificationController notificationController =
      Get.put(NotificationController());
  @override
  void onInit() {
    super.onInit();
    listenToOrders();
  }

  // Lấy userId của khách hàng hiện tại
  Future<String> getCurrentUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? ''; // Nếu không có user, trả về chuỗi rỗng
  }

  // Lắng nghe các thay đổi của đơn hàng
  void listenToOrders() async {
    try {
      isLoading.value = true; // Bắt đầu loading

      final currentUserId = await getCurrentUserId();

      if (currentUserId.isEmpty) {
        print("User not logged in.");
        return;
      }

      FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: currentUserId) // Lọc theo userId
          .snapshots()
          .listen((querySnapshot) {
        final List<OrderAdmin> loadedOrders = querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          print(
              'Order ID: ${doc.id}, Order Status: ${data['orderStatus']}'); // Thêm lệnh in ra log
          return OrderAdmin(
            documentId: doc.id,
            userId: data['userId'],
            userName: data['userName'],
            userPhone: data['userPhone'],
            userAddress: data['userAddress'],
            orderDate: data['orderDate'] is Timestamp
                ? (data['orderDate'] as Timestamp).toDate()
                : DateTime.parse(data['orderDate']),
            products: (data['products'] as List)
                .map((item) => OrderItemAdmin.fromMap(item))
                .toList(),
            totalPrice: double.parse(data['totalPrice'].toString()),
            paymentMethod: int.parse(data['paymentMethod'].toString()),
            orderStatus: int.parse(
                data['orderStatus'].toString()), // Lấy orderStatus từ Firestore
          );
        }).toList();
        orders.value = loadedOrders; // Cập nhật danh sách đơn hàng
      });
    } catch (e) {
      print("Error initializing order listener: $e");
    } finally {
      isLoading.value = false; // Kết thúc loading
    }
  }

  // Cập nhật trạng thái đơn hàng
  Future<void> updateOrderStatus(OrderAdmin order, int newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(order.documentId)
          .update({
        'orderStatus': newStatus, // Cập nhật trạng thái mới
      });
    } catch (e) {
      print("Error updating order status: $e");
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .delete();
      orders.removeWhere((order) => order.documentId == orderId);
    } catch (e) {
      print("Error deleting order: $e");
    }
  }
  Future<void> notificationOrderStatus(OrderAdmin order, int newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(order.documentId)
          .update({
        'orderStatus': newStatus,
      });
      notificationController.sendOrderUpdateNotification(order.documentId!);
    } catch (e) {
      print("Error updating order status: $e");
    }
  }
}
