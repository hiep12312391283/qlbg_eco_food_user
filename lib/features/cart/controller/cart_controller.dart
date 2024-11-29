import 'package:get/get.dart';
import 'package:qlbh_eco_food/features/cart/model/cart_model.dart';
import 'package:qlbh_eco_food/features/home/models/product_models.dart';

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;
  var totalPrice = 0.0.obs;

  void addToCart(Product product, int quantity) {
    final index = cartItems.indexWhere((item) => item.product.id == product.id);
    if (index == -1) {
      cartItems.add(CartItem(product: product, quantity: quantity));
    } else {
      cartItems[index].quantity += quantity;
    }
    calculateTotalPrice();
  }

  void removeFromCart(Product product) {
    cartItems.removeWhere((item) => item.product.id == product.id);
    calculateTotalPrice();
  }

  void updateQuantity(Product product, int quantity) {
    final index = cartItems.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      cartItems[index].quantity = quantity;
      calculateTotalPrice();
      cartItems.refresh(); // Cập nhật giao diện
    }
  }

  void calculateTotalPrice() {
    totalPrice.value = cartItems.fold(
        0.0, (sum, item) => sum + item.product.price * item.quantity);
  }
}
