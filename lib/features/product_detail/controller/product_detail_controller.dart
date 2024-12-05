import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlbh_eco_food/features/cart/model/cart_model.dart';
import 'package:qlbh_eco_food/features/home/models/product_models.dart';
import 'package:qlbh_eco_food/features/product_detail/models/comment.dart';
import 'package:qlbh_eco_food/features/register/model/user.dart';

class ProductDetailController extends GetxController {
  var comments = <Comment>[].obs;
  var isLoadingComments = true.obs; // Thêm trạng thái loading bình luận
  final commentController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel? user;
  var cartItems = <CartItem>[].obs;
  var totalPrice = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadCurrentUser();
  }

  Future<void> loadCurrentUser() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();

      if (doc.exists) {
        user = UserModel.fromFirestore(doc);
        print("User data loaded: ${user!.name}");
      }
    } catch (e) {
      print("Lỗi khi tải thông tin người dùng: $e");
    }
  }

  void addComment(String productId) {
    if (commentController.text.isNotEmpty && user != null) {
      final newComment = Comment(
        id: '', // Đặt id tạm thời
        userName: user!.name,
        content: commentController.text,
        productId: productId,
        userId: user!.id,
        createdAt: DateTime.now(),
      );

      _firestore.collection('comments').add(newComment.toJson()).then((docRef) {
        newComment.id = docRef.id; // Cập nhật id sau khi thêm vào Firestore
        comments.add(newComment);
      }).catchError((e) {
        print("Lỗi khi thêm bình luận vào Firestore: $e");
      });

      commentController.clear();
    } else {
      print("Người dùng chưa được tải hoặc bình luận rỗng");
    }
  }

  void updateComment(String commentId, String newContent) {
    if (user != null) {
      _firestore.collection('comments').doc(commentId).update({
        'content': newContent,
      }).then((_) {
        // Cập nhật bình luận trong danh sách
        var comment = comments.firstWhere((c) => c.id == commentId);
        comment.content = newContent;
        comments.refresh();
      }).catchError((e) {
        print("Lỗi khi cập nhật bình luận: $e");
      });
    }
  }

  void deleteComment(String commentId) {
    if (user != null) {
      _firestore.collection('comments').doc(commentId).delete().then((_) {
        // Xóa bình luận khỏi danh sách
        comments.removeWhere((c) => c.id == commentId);
      }).catchError((e) {
        print("Lỗi khi xóa bình luận: $e");
      });
    }
  }

  void loadComments(String productId) {
    isLoadingComments.value = true; // Đánh dấu bắt đầu loading

    _firestore
        .collection('comments')
        .where('productId', isEqualTo: productId)
        .snapshots()
        .listen((snapshot) async {
      List<Comment> loadedComments = [];
      for (var doc in snapshot.docs) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(doc['userId']).get();
        UserModel commentUser = UserModel.fromFirestore(userDoc);

        var createdAt = doc['createdAt'];
        DateTime commentDateTime;

        if (createdAt is Timestamp) {
          commentDateTime = createdAt.toDate();
        } else if (createdAt is String) {
          try {
            commentDateTime = DateTime.parse(createdAt);
          } catch (e) {
            commentDateTime = DateTime.now();
          }
        } else {
          commentDateTime = DateTime.now();
        }

        loadedComments.add(Comment(
          id: doc.id,
          userName: commentUser.name,
          content: doc['content'],
          productId: doc['productId'],
          userId: doc['userId'],
          createdAt: commentDateTime,
        ));
      }

      loadedComments.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      comments.value = loadedComments;
      isLoadingComments.value = false; // Đánh dấu kết thúc loading
    });
  }

  void addToCart(Product product, int quantity) {
    final index = cartItems.indexWhere((item) => item.product.id == product.id);
    if (index == -1) {
      cartItems.add(CartItem(product: product, quantity: quantity));
    } else {
      cartItems[index].quantity += quantity;
    }
    calculateTotalPrice();
  }

  void calculateTotalPrice() {
    totalPrice.value = cartItems.fold(
        0.0, (sum, item) => sum + item.product.price * item.quantity);
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }
}
