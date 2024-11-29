class OrderAdmin {
  final String userId;
  final String userName;
  final String userPhone;
  final String userAddress;
  final DateTime orderDate;
  final List<OrderItemAdmin> products;
  final double totalPrice;
  final int paymentMethod;
  final String imageBase64;

  OrderAdmin({
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.userAddress,
    required this.orderDate,
    required this.products,
    required this.totalPrice,
    required this.paymentMethod,
    required this.imageBase64,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'userPhone': userPhone,
      'userAddress': userAddress,
      'orderDate': orderDate.toIso8601String(),
      'products': products.map((item) => item.toJson()).toList(),
      'totalPrice': totalPrice,
      'paymentMethod': paymentMethod,
      'imageBase64': imageBase64,
    };
  }

  factory OrderAdmin.fromMap(Map<String, dynamic> map) {
    return OrderAdmin(
        userId: map['userId'],
        userName: map['userName'],
        userPhone: map['userPhone'],
        userAddress: map['userAddress'],
        orderDate: DateTime.parse(map['orderDate']),
        products: List<OrderItemAdmin>.from(
          map['products']?.map((item) => OrderItemAdmin.fromMap(item)),
        ),
        totalPrice: map['totalPrice'],
        paymentMethod: map['paymentMethod'],
        imageBase64: map['imageBase64'] ?? '');
  }
}

class OrderItemAdmin {
  final String productId;
  final String productName;
  final int quantity;
  final double price;
  final String imageBase64; // Thêm trường ảnh sản phẩm

  OrderItemAdmin({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.imageBase64,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'imageBase64': imageBase64, // Bao gồm ảnh sản phẩm
    };
  }

  factory OrderItemAdmin.fromMap(Map<String, dynamic> map) {
    return OrderItemAdmin(
      productId: map['productId'],
      productName: map['productName'],
      quantity: map['quantity'],
      price: map['price'],
      imageBase64: map['imageBase64'] ?? '', // Bao gồm ảnh sản phẩm
    );
  }
}
