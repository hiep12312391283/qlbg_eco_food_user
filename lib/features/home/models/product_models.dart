class Product {
  String id;
  String name;
  String category;
  double price;
  String description;
  int stock;
  DateTime entryDate;
  DateTime expiryDate;
  String imageBase64;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.stock,
    required this.entryDate,
    required this.expiryDate,
    required this.imageBase64, // Đổi tên biến để phản ánh rằng nó lưu trữ ảnh dưới dạng base64
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'description': description,
      'stock': stock,
      'entryDate': entryDate.toIso8601String(),
      'expiryDate': expiryDate.toIso8601String(),
      'imageBase64': imageBase64, // Sử dụng imageBase64 để lưu trữ ảnh
    };
  }
}
