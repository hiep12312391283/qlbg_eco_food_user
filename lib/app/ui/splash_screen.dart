import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigatorNextScreen();
    });
  }

  void navigatorNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    Get.toNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: SvgPicture.asset(
              'assets/image/logo.svg',
              width: 200,
              height: 200,
            ),
          ),
          const Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Thực phẩm sạch - Lựa chọn an toàn cho',
                  style: TextStyle(
                    color: Color(0xFF83C167),
                    fontFamily: 'Oswald',
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'cuộc sống khỏe mạnh',
                  style: TextStyle(
                    color: Color(0xFF83C167),
                    fontFamily: 'Oswald',
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
