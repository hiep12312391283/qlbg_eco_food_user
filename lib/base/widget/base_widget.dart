import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlbh_eco_food/base/const/app_text_style.dart';
import 'package:qlbh_eco_food/base/const/colors.dart';
import 'package:qlbh_eco_food/features/cart/controller/cart_controller.dart';
import 'package:qlbh_eco_food/features/cart/view/cart_view.dart';

class BaseWidget {
  static Widget buildText(
    String text, {
    FontWeight? fontWeight,
    TextAlign? textAlign,
    Color? textColor,
    int? maxLines,
    double? fontSize,
    TextStyle? style,
  }) {
    return AutoSizeText(
      text,
      textAlign: textAlign ?? TextAlign.center,
      style: style ??
          AppTextStyle.font12Re.copyWith(
              fontWeight: fontWeight,
              overflow: TextOverflow.ellipsis,
              color: textColor),
      maxLines: maxLines ?? 1,
    );
  }

  static Widget buildIconAppBar({
    Function()? onTap,
    required IconButton icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: icon,
    );
  }

  static Widget buildAppBarCustom(
      {Color backgroundColor = AppColors.backgroundColor,
      String hintText = "Nhập để tìm kiếm..."}) {
    final CartController cartController = Get.find();
    return Container(
      color: AppColors.green,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(
                      Icons.search_rounded,
                      color: Colors.grey,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: const TextStyle(
                            fontFamily: "Oswald",
                            color: Colors.grey,
                            fontWeight: FontWeight.w300),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ).paddingOnly(right: 8),
          ),
          Obx(() {
            int itemCount = cartController.cartItems.length;
            return Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart_outlined),
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
      ).paddingSymmetric( vertical: 16).paddingOnly(left: 12),
    );
  }

  static Widget buildButtonShoppingCart() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.shopping_cart,
          color: Colors.white,
        ),
        BaseWidget.buildText(
          "Mua ngay",
          style: AppTextStyle.font16Re.copyWith(color: Colors.white),
        ).paddingSymmetric(horizontal: 12)
      ],
    );
  }
}
