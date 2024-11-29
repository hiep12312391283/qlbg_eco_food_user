import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlbh_eco_food/base/const/app_text_style.dart';
import 'package:qlbh_eco_food/base/const/colors.dart';
import 'package:qlbh_eco_food/base/widget/base_widget.dart';
import 'package:qlbh_eco_food/features/home/view/home_page.dart';
import 'package:qlbh_eco_food/features/home_page/home_page_controller.dart';
import 'package:qlbh_eco_food/features/nofitication/views/notification_page.dart';
import 'package:qlbh_eco_food/features/order/view/order_page.dart';
import 'package:qlbh_eco_food/features/profile/views/profile_page.dart';

class HomePageView extends GetView<HomePageController> {
  HomePageView({super.key});
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Obx(() {
          return controller.pageIndex.value != 4
              ? AppBar(
                  automaticallyImplyLeading: false,
                  titleSpacing: 0,
                  title: BaseWidget.buildAppBarCustom(),
                )
              : AppBar(
                  backgroundColor: AppColors.backgroundColor,
                  automaticallyImplyLeading: false,
                  title: BaseWidget.buildText(
                    "Tài khoản",
                    style: AppTextStyle.font24Re,
                  ),
                  centerTitle: true,
                );
        }),
      ),
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: (index) {
            controller.pageIndex.value = index;
          },
          children: [
            HomePage(),
            // ListProductPage(),
            OrderPage(),
            NotificationPage(),
            ProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(splashFactory: NoSplash.splashFactory),
        child: Obx(
          () => BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Trang chủ',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt),
                label: 'Danh Mục',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_shipping),
                label: "Đơn hàng",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: "Thông Báo",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Tài Khoản',
              ),
            ],
            type: BottomNavigationBarType.fixed,
            currentIndex: controller.pageIndex.value,
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.green,
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              controller.pageIndex.value = index;
              _pageController.jumpToPage(index);
            },
          ),
        ),
      ),
    );
  }
}
