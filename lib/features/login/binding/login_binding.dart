import 'package:get/get.dart';
import 'package:qlbh_eco_food/features/login/controller/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
