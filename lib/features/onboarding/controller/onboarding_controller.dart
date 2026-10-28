import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hop_talk/core/services/storage_service.dart';
import 'package:hop_talk/routes/app_routes.dart';

import '../models/onboarding_model.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();

  RxInt selectedPageIndex = 0.obs;

  bool get isLastPage => selectedPageIndex.value == onboardingPages.length - 1;
  bool get isFirstPage => selectedPageIndex.value == 0;

  void updatePageIndicator(int index) {
    selectedPageIndex.value = index;
  }

  void forwardAction() {
    if (isLastPage) {
      StorageService.setOnboardingComplete(true);
      Get.offAllNamed(AppRoutes.setupScreen);
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skipAction() {
    StorageService.setOnboardingComplete(true);
    Get.offAllNamed(AppRoutes.setupScreen);
  }

  void backwordAction() {
    if (isFirstPage) {
    } else {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  List<OnboardingInfo> onboardingPages = [
    OnboardingInfo(
      title: 'No internet?\nNo problem.',
      description: 'Send direct end-to-end encrypted messages even during power cuts, transit, or remote travels.',
      image: 'assets/onboarding/onboard_1.png',
    ),
    OnboardingInfo(
      title: 'Nearby phones\nbecome your network.',
      description: 'Each device acts as a secure relay station. Your messages hop seamlessly from phone to phone until reaching your recipient.',
      image: 'assets/onboarding/onboard_2.png',
    ),
    OnboardingInfo(
      title: 'One radio device\nreaches kilometers.',
      description: 'Pair an external pocket LoRa radio to send messages across mountains, valleys, and wilderness without cellular towers.',
      image: 'assets/onboarding/onboard_3.png',
    ),
  ];

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
