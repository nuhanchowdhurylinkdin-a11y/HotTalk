import 'package:get/get.dart';
import 'package:hop_talk/features/onboarding/controller/onboarding_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(
          () => OnboardingController(),
      fenix: true,
    );
  }
}
