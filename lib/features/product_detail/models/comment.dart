import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String id; // Added id attribute
  String userName;
  String content;
  String productId;
  String userId;
  DateTime
      createdAt; // Added createdAt attribute to fromDocumentSnapshot method

  Comment({
    required this.id, // Added id attribute to constructor
    required this.userName,
    required this.content,
    required this.productId,
    required this.userId,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'content': content,
      'productId': productId,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(), // Ensure DateTime is serialized
    };
  }

  factory Comment.fromDocumentSnapshot(DocumentSnapshot doc) {
    return Comment(
      id: doc.id, // Assign id from DocumentSnapshot
      userName: doc['userName'],
      content: doc['content'],
      productId: doc['productId'],
      userId: doc['userId'],
      createdAt: (doc['createdAt'] as Timestamp)
          .toDate(), // Convert Timestamp to DateTime
    );
  }
}
