import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
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

  // Fetch user data from Firestore
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

  // Place an order
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
        documentId: '', 
        userId: userId,
        userName: userName.value,
        userPhone: userPhone.value,
        userAddress: userAddress.value,
        orderDate: currentDateTime,
        products: orderItems,
        totalPrice: cartController.totalPrice.value,
        paymentMethod: paymentMethod.value,
        orderStatus: 0,
      );

      // Gọi hàm addOrder để thêm đơn hàng vào Firestore và Realtime Database
      addOrder(order);

      print('Order placed successfully');
    } catch (e) {
      print('Error placing order: $e');
    }
  }

  // Thêm đơn hàng vào Firestore và Realtime Database
  void addOrder(OrderAdmin order) {
    // Thêm đơn hàng vào Firestore
    _firestore.collection('orders').add(order.toJson()).then((docRef) {
      // Lấy document ID từ Firestore
      final updatedOrder = OrderAdmin(
        documentId: docRef.id, // Cập nhật ID của document
        userId: order.userId,
        userName: order.userName,
        userPhone: order.userPhone,
        userAddress: order.userAddress,
        orderDate: order.orderDate,
        products: order.products,
        totalPrice: order.totalPrice,
        paymentMethod: order.paymentMethod,
        orderStatus: order.orderStatus,
      );

      // Cập nhật lại danh sách đơn hàng với ID mới
      orders.add(updatedOrder);
      print('Order added to Firestore with document ID: ${docRef.id}');

      // Thêm đơn hàng vào Realtime Database
      _database
          .ref()
          .child('orders')
          .child(order.userId)
          .child(docRef.id) // Sử dụng document ID của Firestore làm key
          .set(updatedOrder.toJson())
          .catchError((e) {
        print("Lỗi khi thêm vào Realtime Database: $e");
      });
    }).catchError((e) {
      print("Lỗi khi thêm vào Firestore: $e");
    });
  }
}
