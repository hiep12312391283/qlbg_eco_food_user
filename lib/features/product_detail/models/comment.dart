import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String userName;
  String content;
  String productId;
  String userId;

  Comment({
    required this.userName,
    required this.content,
    required this.productId,
    required this.userId, // Khởi tạo thuộc tính userId
  });

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'content': content,
      'productId': productId,
      'userId': userId,
    };
  }

  factory Comment.fromDocumentSnapshot(DocumentSnapshot doc) {
    return Comment(
      userName: doc['userName'],
      content: doc['content'],
      productId: doc['productId'],
      userId: doc['userId'],
    );
  }
}
