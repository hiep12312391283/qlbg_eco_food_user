import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    // Yêu cầu quyền thông báo cho người dùng (iOS)
    await _firebaseMessaging.requestPermission();

    // Lấy device token
    String? token = await _firebaseMessaging.getToken();
    print("Device Token: $token");

    // Lắng nghe khi có thông báo trong nền hoặc khi ứng dụng mở
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          'Received a message: ${message.notification?.title}, ${message.notification?.body}');
    });
  }
}
