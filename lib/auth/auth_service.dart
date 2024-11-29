import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signUpWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Gửi email xác nhận
      await userCredential.user?.sendEmailVerification();
    } catch (e) {
      print("Lỗi: $e");
      throw e;
    }
  }

  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null && userCredential.user!.emailVerified) {
        return userCredential.user;
      } else {
        await _auth.signOut();
        return null;
      }
    } catch (e) {
      print("Lỗi: $e");
      throw e;
    }
  }
}
