import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qlbh_eco_food/app/controller/app_controller.dart';
import 'package:qlbh_eco_food/features/home/models/product_models.dart';

class HomeController extends GetxController {
  late Rx<PageController> pageController;
  var currentIndex = 0.obs;
  final endTime = DateTime.now().second + 600;
  RxInt pageIndex = 0.obs;
  final appController = Get.find<AppController>();
  // Các controller cho các trường đầu vào
  final idController = TextEditingController();
  final nameController = TextEditingController();
  final categoryController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final stockController = TextEditingController();
  final expiryDateController = TextEditingController();
  final searchController = TextEditingController();

  final idError = ''.obs;
  final nameError = ''.obs;
  final categoryError = ''.obs;
  final priceError = ''.obs;
  final descriptionError = ''.obs;
  final stockError = ''.obs;
  var searchQuery = ''.obs;

  final formKey = GlobalKey<FormState>();
  var products = <Product>[].obs;
  var selectedImagePath = ''.obs;
  final picker = ImagePicker();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> checkAndRequestPermissions() async {
    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    }
  }

  Future<void> fetchProducts() async {
    try {
      // Sử dụng Stream để lắng nghe các thay đổi trong Firestore
      _firestore.collection('products').snapshots().listen((querySnapshot) {
        final List<Product> loadedProducts = querySnapshot.docs.map((doc) {
          final data = doc.data();

          // Kiểm tra các trường có thể là null và cung cấp giá trị mặc định
          return Product(
            id: data['id'] ??
                '', // Nếu 'id' là null, gán giá trị mặc định là chuỗi rỗng
            name: data['name'] ??
                '', // Nếu 'name' là null, gán giá trị mặc định là chuỗi rỗng
            categoryId: data['categoryId'] ??
                '', // Nếu 'category' là null, gán giá trị mặc định là chuỗi rỗng
            price: data['price'] ??
                0.0, // Nếu 'price' là null, gán giá trị mặc định là 0.0
            description: data['description'] ??
                '', // Nếu 'description' là null, gán giá trị mặc định là chuỗi rỗng
            stock: data['stock'] ??
                0, // Nếu 'stock' là null, gán giá trị mặc định là 0
            expiryDate: data['expiryDate'] is Timestamp
                ? (data['expiryDate'] as Timestamp).toDate()
                : DateTime.parse(data['expiryDate'] ??
                    DateTime.now()
                        .toString()), // Kiểm tra 'expiryDate' có null không
            imageBase64: data['imageBase64'] ??
                '', // Nếu 'imageBase64' là null, gán giá trị mặc định là chuỗi rỗng
          );
        }).toList();

        // Gán danh sách sản phẩm đã tải vào Rx list
        products.value = loadedProducts;
      });
    } catch (e) {
      print("Lỗi khi tải sản phẩm từ Firestore: $e");
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    // Lọc sản phẩm theo truy vấn tìm kiếm
    products.refresh();
  }
}
