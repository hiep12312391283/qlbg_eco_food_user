import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlbh_eco_food/features/product_detail/models/comment.dart';
import 'package:qlbh_eco_food/features/register/model/user.dart';

class ProductDetailController extends GetxController {
  var comments = <Comment>[].obs;
  final commentController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel? user; // Thêm thuộc tính user

  @override
  void onInit() {
    super.onInit();
    loadCurrentUser(); // Tải thông tin người dùng khi khởi tạo controller
  }

  void loadCurrentUser() async {
    String currentUserId =
        'BNZJM4j5kyNEcStjNGHsXUHhr782'; // Đặt userId hiện tại (thay đổi theo logic của bạn)
    DocumentSnapshot doc =
        await _firestore.collection('users').doc(currentUserId).get();
    user = UserModel.fromFirestore(doc);
  }

  void addComment(String productId) {
    if (commentController.text.isNotEmpty && user != null) {
      final newComment = Comment(
        userName: user!.name,
        content: commentController.text,
        productId: productId,
        userId: user!.id,
      );
      comments.add(newComment);
      _firestore
          .collection('comments')
          .add(newComment.toJson())
          .catchError((e) {
        print("Lỗi khi thêm bình luận vào Firestore: $e");
      });
      commentController.clear();
    } else {
      print("Người dùng chưa được tải hoặc bình luận rỗng");
    }
  }

  void loadComments(String productId) {
    _firestore
        .collection('comments')
        .where('productId', isEqualTo: productId)
        .snapshots()
        .listen((snapshot) async {
      List<Comment> loadedComments = [];
      for (var doc in snapshot.docs) {
        // Lấy thông tin người dùng cho từng bình luận
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(doc['userId']).get();
        UserModel commentUser = UserModel.fromFirestore(userDoc);

        loadedComments.add(Comment(
          userName: commentUser.name,
          content: doc['content'],
          productId: doc['productId'],
          userId: doc['userId'],
        ));
      }
      comments.value = loadedComments;
    });
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }
}
