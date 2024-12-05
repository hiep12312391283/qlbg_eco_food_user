import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qlbh_eco_food/base/const/colors.dart';
import 'package:qlbh_eco_food/features/cart/controller/cart_controller.dart';
import 'package:qlbh_eco_food/features/home/models/product_models.dart';
import 'package:qlbh_eco_food/features/product_detail/controller/product_detail_controller.dart';
import 'package:qlbh_eco_food/features/product_detail/models/comment.dart';

class ProductDetailPage extends GetView<ProductDetailController> {
  final ProductDetailController controller = Get.put(ProductDetailController());

  @override
  Widget build(BuildContext context) {
    final Product? product = Get.arguments as Product?;

    if (product == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Lỗi'),
        ),
        body: Center(
          child: Text('Lỗi: Không tìm thấy sản phẩm.'),
        ),
      );
    }

    controller.loadComments(product.id);

    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin chi tiết'),
        centerTitle: true,
        backgroundColor: AppColors.backgroundColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProductImage(product),
            SizedBox(height: 16),
            _buildProductInfo(product),
            SizedBox(height: 16),
            _buildDescription(product),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 8),
            _buildCommentsSection(),
            SizedBox(height: 16),
            _buildCommentInput(context, product.id),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            _showBottomSheet(context, product, Get.find<CartController>());
          },
          child: Text(
            'Thêm vào giỏ hàng',
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.green,
            minimumSize: Size(double.infinity, 50),
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage(Product product) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: MemoryImage(base64Decode(product.imageBase64)),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProductInfo(Product product) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '${formatPrice(product.price)} VND',
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
            SizedBox(height: 8),
            Text(
              'Số lượng còn trong kho: ${product.stock}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription(Product product) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mô tả:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              product.description,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Obx(() {
      // Hiển thị loading trong khi dữ liệu đang được tải
      if (controller.isLoadingComments.value) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      // Kiểm tra nếu không có bình luận
      if (controller.comments.isEmpty) {
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Chưa có bình luận nào. Hãy là người đầu tiên bình luận!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        );
      }

      // Hiển thị danh sách bình luận
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bình luận:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: controller.comments.length,
                itemBuilder: (context, index) {
                  final comment = controller.comments[index];
                  String formattedDate =
                      DateFormat('dd/MM/yyyy').format(comment.createdAt);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  comment.userName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  formattedDate,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(comment.content),
                      SizedBox(height: 8),
                      if (comment.userId == controller.user?.id)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton.icon(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                label: Text('Chỉnh sửa',
                                    style: TextStyle(color: Colors.blue)),
                                onPressed: () {
                                  _editComment(context, comment);
                                },
                              ),
                              SizedBox(width: 16),
                              TextButton.icon(
                                icon: Icon(Icons.delete, color: Colors.red),
                                label: Text('Xóa',
                                    style: TextStyle(color: Colors.red)),
                                onPressed: () {
                                  _deleteComment(context, comment);
                                },
                              ),
                            ],
                          ),
                        ),
                      Divider(height: 1),
                    ],
                  ).paddingSymmetric(horizontal: 12).paddingOnly(bottom: 12);
                },
              ),
            ],
          ),
        ),
      );
    });
  }




  void _editComment(BuildContext context, Comment comment) {
    TextEditingController editController = TextEditingController(
        text: comment.content); // Gán nội dung vào TextEditingController
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Chỉnh sửa bình luận'),
          content: Column(
            mainAxisSize: MainAxisSize
                .min, // Đảm bảo nội dung không chiếm quá nhiều không gian
            children: [
              TextField(
                controller: editController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nhập nội dung bình luận...',
                ),
                maxLines: 5, // Cho phép người dùng nhập nhiều dòng
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                // Gửi nội dung cập nhật khi nhấn "Lưu"
                if (editController.text.isNotEmpty) {
                  controller.updateComment(comment.id, editController.text);
                  Navigator.of(context).pop();
                } else {
                  Get.snackbar(
                      'Thông báo', 'Nội dung bình luận không thể trống.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white);
                }
              },
              child: Text('Lưu'),
            ),
          ],
        );
      },
    );
  }


  void _deleteComment(BuildContext context, Comment comment) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Xóa bình luận'),
          content: Text('Bạn có chắc chắn muốn xóa bình luận này không?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                controller.deleteComment(comment.id);
                Navigator.of(context).pop();
              },
              child: Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCommentInput(BuildContext context, String productId) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.commentController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Nhập bình luận của bạn...',
                ),
              ),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                controller.addComment(productId);
              },
              child: Icon(Icons.send, color: Colors.white),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(12),
                backgroundColor: AppColors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatPrice(double price) {
    var formatter = NumberFormat("#,###");
    return formatter.format(price);
  }

  void _showBottomSheet(
      BuildContext context, Product product, CartController cartController) {
    RxInt quantity = 1.obs;
    RxDouble subtotal = product.price.obs;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  product.imageBase64.isNotEmpty
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
                      : Icon(Icons.image_not_supported, size: 50),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${formatPrice(product.price)} VND',
                          style: TextStyle(color: Colors.green, fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Còn lại: ${product.stock}',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Số lượng', style: TextStyle(fontSize: 16)),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          if (quantity.value > 1) {
                            quantity.value--;
                            subtotal.value = product.price * quantity.value;
                          }
                        },
                      ),
                      Obx(() => Text('${quantity.value}',
                          style: TextStyle(fontSize: 16))),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          if (quantity.value < product.stock) {
                            quantity.value++;
                            subtotal.value = product.price * quantity.value;
                          } else {
                            Get.snackbar('Thông báo', 'Không đủ hàng trong kho',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                colorText: Colors.white);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tạm tính', style: TextStyle(fontSize: 16)),
                  Obx(() => Text('${formatPrice(subtotal.value)} VND',
                      style: TextStyle(fontSize: 16))),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (quantity.value <= product.stock) {
                    cartController.addToCart(product, quantity.value);
                    Navigator.pop(context);
                  } else {
                    Get.snackbar('Thông báo', 'Không đủ hàng trong kho',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white);
                  }
                },
                child: Text('Thêm vào giỏ hàng'),
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 40)),
              ),
            ],
          ),
        );
      },
    );
  }
}
