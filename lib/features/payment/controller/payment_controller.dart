import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qlbh_eco_food/features/cart/controller/cart_controller.dart';
import 'package:qlbh_eco_food/features/payment/model/order_model.dart';

class PaymentController extends GetxController {
  var paymentMethod = 1.obs;
  var userName = ''.obs;
  var userPhone = ''.obs;
  var userAddress = ''.obs;
  var orders = <OrderAdmin>[].obs;
  final CartController cartController = Get.put(CartController());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        print('User is not logged in');
        return;
      }

      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        userName.value = data['name'] ?? '';
        userPhone.value = data['phone'] ?? '';
        userAddress.value = data['address'] ?? '';
      } else {
        print('User document not found');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  void placeOrder() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        print('User is not logged in');
        return;
      }

      final currentDateTime = DateTime.now();

      final orderItems = cartController.cartItems
          .map((item) => OrderItemAdmin(
                productId: item.product.id,
                productName: item.product.name,
                quantity: item.quantity,
                price: item.product.price,
                imageBase64: item.product.imageBase64, // Bao gồm ảnh sản phẩm
              ))
          .toList();

      final order = OrderAdmin(
        userId: userId,
        userName: userName.value,
        userPhone: userPhone.value,
        userAddress: userAddress.value,
        orderDate: currentDateTime,
        products: orderItems,
        totalPrice: cartController.totalPrice.value,
        paymentMethod: paymentMethod.value,
        imageBase64:
            "", // Trường này có vẻ không cần thiết trong OrderAdmin, có thể xóa đi nếu không dùng
      );

      // Gọi hàm addOrder để thêm đơn hàng vào Firestore và Realtime Database
      addOrder(order);

      print('Order placed successfully');
    } catch (e) {
      print('Error placing order: $e');
    }
  }

  void addOrder(OrderAdmin order) {
    orders.add(order);
    _firestore.collection('orders').add(order.toJson()).catchError((e) {
      print("Lỗi khi thêm vào Firestore: $e");
    });
    _database
        .ref()
        .child('orders') // Sửa lại từ 'order' thành 'orders'
        .child(order.userId) // sử dụng order.userId làm key
        .set(order.toJson())
        .catchError((e) {
      print("Lỗi khi thêm vào Realtime Database: $e");
    });
  }
}
