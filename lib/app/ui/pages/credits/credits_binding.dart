import 'package:get/get.dart';
import 'credits_controller.dart';
import 'package:loom_ai_app/app/services/purchase_service.dart';

class CreditsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreditsController(purchaseService: Get.find<PurchaseService>()));
  }
}