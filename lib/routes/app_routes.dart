import 'package:get/route_manager.dart';
import 'package:hop_talk/features/onboarding/views/screens/onboarding_screen.dart';

class AppRoutes {
  static String onboardingScreen = "/onboardingScreen";

  static List<GetPage> routes =[
    GetPage(name: onboardingScreen, page: () => const OnboardingScreen()),
  ];
}