import 'package:qlbh_eco_food/features/home/models/product_models.dart';

class CartItem {
  Product product;
  int quantity;
  CartItem({
    required this.product,
    required this.quantity,
  });
}
