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
    required this.imageBase64,
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
      'imageBase64': imageBase64,
    };
  }
}
