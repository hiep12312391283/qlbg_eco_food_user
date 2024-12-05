import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlbh_eco_food/base/const/app_text_style.dart';
import 'package:qlbh_eco_food/base/const/colors.dart';
import 'package:qlbh_eco_food/features/cart/controller/cart_controller.dart';
import 'package:qlbh_eco_food/features/cart/view/cart_view.dart';
import 'package:qlbh_eco_food/features/category/controller/category_controller.dart';
import 'dart:convert';
import 'package:qlbh_eco_food/features/home/models/product_models.dart';
import 'package:intl/intl.dart';
import 'package:qlbh_eco_food/features/search_product/view/search_product_page.dart'; // Import for number formatting

class CategoryView extends StatelessWidget {
  final CategoryController controller = Get.put(CategoryController());
  final CartController cartController = Get.put(CartController());

  CategoryView() {
    controller.fetchProducts();
  }

  String formatPrice(double price) {
    var formatter = NumberFormat("#,###");
    if (price == price.truncateToDouble()) {
      return formatter.format(price);
    } else {
      formatter = NumberFormat("#,###.00");
      return formatter.format(price);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Danh mục sản phẩm',
          style: AppTextStyle.font24Semi.copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Get.to(SearchProductPage());
            },
          ),
          Obx(() {
            int itemCount = cartController.cartItems.length;
            return Stack(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Get.to(() => CartPage());
                  },
                ),
                if (itemCount > 0)
                  Positioned(
                    right: 11,
                    top: 11,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$itemCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          }).paddingOnly(right: 8),
        ],
        backgroundColor: AppColors.green.shade400,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.productsByCategory.isEmpty) {
          return Center(child: Text("No products available"));
        }

        return ListView.builder(
          itemCount: controller.productsByCategory.length,
          itemBuilder: (context, index) {
            String categoryId =
                controller.productsByCategory.keys.elementAt(index);
            List<Product> categoryProducts =
                controller.productsByCategory[categoryId]!;

            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ExpansionTile(
                  title: Text(
                    categoryId,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: categoryProducts.map((product) {
                    var formattedPrice = formatPrice(product.price);
                    var imageWidget = product.imageBase64.isNotEmpty
                        ? Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: MemoryImage(
                                    base64Decode(product.imageBase64)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Icon(Icons.image_not_supported, size: 50);

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Colors.teal, // Border color
                          width: 2, // Border width
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          Get.toNamed('/product_detail', arguments: product);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              imageWidget,
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '$formattedPrice VND',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.add_shopping_cart,
                                    color: Colors.teal),
                                onPressed: () {
                                  // Assuming you have a cart controller and method to handle this
                                  // cartController.addToCart(product);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
