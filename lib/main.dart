import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:qlbh_eco_food/app/binding/global_binding.dart';
import 'package:qlbh_eco_food/app/ui/splash_screen.dart';
import 'package:qlbh_eco_food/features/cart/view/cart_view.dart';
import 'package:qlbh_eco_food/features/home/bindings/home_bindings.dart';
import 'package:qlbh_eco_food/features/home/view/home_page.dart';
import 'package:qlbh_eco_food/features/home_page/home_page_binding.dart';
import 'package:qlbh_eco_food/features/home_page/home_page_view.dart';
import 'package:qlbh_eco_food/features/login/binding/login_binding.dart';
import 'package:qlbh_eco_food/features/login/view/login_page.dart';
import 'package:qlbh_eco_food/features/product_detail/views/product_detail_page.dart';
import 'package:qlbh_eco_food/features/profile/views/profile_page.dart';
import 'package:qlbh_eco_food/features/register/view/register_page.dart';

void main() {
  _init();
}

void _init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final options = Firebase.app().options;
  print('Project ID: ${options.projectId}');
  print('App ID: ${options.appId}');
  print('API Key: ${options.apiKey}');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SplashPage(),
        initialBinding: GlobalBinding(),
        getPages: [
          GetPage(
              name: '/login',
              page: () => LoginPage(onTap: () {}),
              binding: LoginBinding()),
          GetPage(
            name: '/register',
            page: () => RegisterPage(
              onTap: () {},
            ),
          ),
          GetPage(
              name: '/home_page',
              page: () => HomePageView(),
              binding: HomePageBinding()),
          GetPage(
            name: '/home',
            page: () => HomePage(),
            binding: HomeBinding(),
          ),
          GetPage(
            name: '/product_detail',
            page: () => ProductDetailPage(),
          ),
          GetPage(
            name: '/account',
            page: () =>  ProfilePage(),
          ),
          GetPage(
            name: '/cart',
            page: () => CartPage(),
          ),
        ],
      ),
    );
  }
}
