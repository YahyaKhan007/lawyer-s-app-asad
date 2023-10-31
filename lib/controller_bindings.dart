import 'package:get/get.dart';
import 'package:laywers_app/services/services.dart';

class ControllerBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(FirebaseAuthController());
    Get.put(LangController());
    Get.put((ChatroomController()));
    Get.put(ChatroomController());
  }
}
