import 'package:get/get.dart';
import 'package:qlbh_eco_food/app/controller/app_controller.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<AppController>(() => AppController(),fenix: true);
  }
}
