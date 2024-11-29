import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePageController extends GetxController {
  late Rx<PageController> pageController;
  var currentIndex = 0.obs;
  RxInt pageIndex = 0.obs;

}
