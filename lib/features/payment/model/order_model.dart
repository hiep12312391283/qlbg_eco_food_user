class OrderAdmin {
  String? documentId;
  final String userId;
  final String userName;
  final String userPhone;
  final String userAddress;
  final DateTime orderDate;
  final List<OrderItemAdmin> products;
  final double totalPrice;
  final int paymentMethod;
  int orderStatus;

  OrderAdmin({
    this.documentId,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.userAddress,
    required this.orderDate,
    required this.products,
    required this.totalPrice,
    required this.paymentMethod,
    required this.orderStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'documentId': documentId,
      'userId': userId,
      'userName': userName,
      'userPhone': userPhone,
      'userAddress': userAddress,
      'orderDate': orderDate.toIso8601String(),
      'products': products.map((item) => item.toJson()).toList(),
      'totalPrice': totalPrice,
      'paymentMethod': paymentMethod,
      'orderStatus': orderStatus,
    };
  }

  factory OrderAdmin.fromMap(Map<String, dynamic> map) {
    return OrderAdmin(
      documentId: map['documentId'],
      userId: map['userId'],
      userName: map['userName'],
      userPhone: map['userPhone'],
      userAddress: map['userAddress'],
      orderDate: DateTime.parse(map['orderDate']),
      products: List<OrderItemAdmin>.from(
        map['products']?.map((item) => OrderItemAdmin.fromMap(item)) ?? [],
      ),
      // Chuyển đổi kiểu 'totalPrice' về double (nếu là int thì chuyển)
      totalPrice: map['totalPrice'] is int
          ? (map['totalPrice'] as int).toDouble()
          : map['totalPrice']?.toDouble() ?? 0.0,
      paymentMethod: map['paymentMethod'] ?? 0,
      // Chuyển đổi kiểu 'orderStatus' về int nếu cần thiết
      orderStatus: map['orderStatus'] is double
          ? (map['orderStatus'] as double).toInt()
          : map['orderStatus'] ?? 0,
    );
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
      // Chuyển đổi kiểu 'price' từ int (nếu có) sang double
      price: map['price'] is int
          ? (map['price'] as int).toDouble()
          : map['price']?.toDouble() ?? 0.0,
      imageBase64: map['imageBase64'] ?? '', // Bao gồm ảnh sản phẩm
    );
  }
}
