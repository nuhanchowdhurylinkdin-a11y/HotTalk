import 'package:get/get.dart';
import 'package:hop_talk/features/home/controller/home_controller.dart';
import 'package:hop_talk/features/onboarding/controller/onboarding_controller.dart';
import 'package:hop_talk/features/setup/controller/setup_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(
          () => OnboardingController(),
      fenix: true,
    );
    Get.lazyPut<SetupController>(
          () => SetupController(),
      fenix: true,
    );

    Get.lazyPut<HomeController>(
          () => HomeController(),
      fenix: true,
    );
  }
}
