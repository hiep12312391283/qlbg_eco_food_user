import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class NotificationController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.instance.subscribeToTopic("order_updates");
  }

  Future<void> sendOrderUpdateNotification(String orderId) async {
    // Gửi thông báo đến topic "order_updates"
    await FirebaseMessaging.instance.sendMessage(
      to: "/topics/order_updates",
      data: {"orderId": orderId, "message": "Đơn hàng đã được cập nhật"},
    );
  }
}
