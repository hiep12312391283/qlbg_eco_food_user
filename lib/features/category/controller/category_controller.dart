import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qlbh_eco_food/features/home/models/product_models.dart';

class CategoryController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var productsByCategory = <String, List<Product>>{}.obs;
  var isLoading = true.obs; // Thêm biến isLoading

  void fetchProducts() {
    try {
      isLoading.value = true; // Đánh dấu bắt đầu tải dữ liệu
      _firestore.collection('products').snapshots().listen((querySnapshot) {
        final Map<String, List<Product>> categoryMap = {};

        querySnapshot.docs.forEach((doc) {
          final data = doc.data() as Map<String, dynamic>;

          // Loại bỏ khoảng trắng trước và sau categoryId
          final categoryId = (data['categoryId'] ?? '')
              .trim(); // Sử dụng trim() để loại bỏ khoảng trắng

          final product = Product(
            id: data['id'] ?? '',
            name: data['name'] ?? '',
            categoryId:
                categoryId, // Dùng categoryId đã loại bỏ khoảng trắng trước và sau
            price: data['price'] ?? 0.0,
            description: data['description'] ?? '',
            stock: data['stock'] ?? 0,
            expiryDate: data['expiryDate'] is Timestamp
                ? (data['expiryDate'] as Timestamp).toDate()
                : DateTime.now(),
            imageBase64: data['imageBase64'] ?? '',
          );

          if (!categoryMap.containsKey(product.categoryId)) {
            categoryMap[product.categoryId] = [];
          }

          categoryMap[product.categoryId]?.add(product);
        });

        productsByCategory.value = categoryMap;
        isLoading.value = false; // Dữ liệu đã được tải xong
      });
    } catch (e) {
      print("Lỗi khi tải sản phẩm từ Firestore: $e");
      isLoading.value = false;
    }
  }
}
