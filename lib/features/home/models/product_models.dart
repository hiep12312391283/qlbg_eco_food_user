class Product {
  String id;
  String categoryId;
  String name;
  double price;
  String description;
  int stock;
  DateTime expiryDate;
  String imageBase64;
  String? documentId; // Thêm thuộc tính này

  Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.price,
    required this.description,
    required this.stock,
    required this.expiryDate,
    required this.imageBase64,
    this.documentId, // Cho phép documentId là null
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'categoryId': categoryId,
      'price': price,
      'description': description,
      'stock': stock,
      'expiryDate': expiryDate.toIso8601String(),
      'imageBase64': imageBase64,
    };
  }
}
