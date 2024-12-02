  import 'package:cloud_firestore/cloud_firestore.dart';

  class UserModel {
    String id;
    String email;
    String phone;
    String name;
    String address;
    String? documentId;

    UserModel({
      required this.id,
      required this.email,
      required this.phone,
      required this.name,
      required this.address,
      this.documentId,
    });

    factory UserModel.fromFirestore(DocumentSnapshot doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return UserModel(
        id: doc.id,
        email: data['email'] ?? '',
        phone: data['phone'] ?? '',
        name: data['name'] ?? '',
        address: data['address'] ?? '',
        documentId: doc.id,
      );
    }

    Map<String, dynamic> toJson() {
      return {
        'id': id,
        'email': email,
        'phone': phone,
        'name': name,
        'address': address,
      };
    }
  }
