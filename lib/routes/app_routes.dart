import 'package:get/route_manager.dart';
import 'package:hop_talk/features/home/views/screen/home_screen.dart';
import 'package:hop_talk/features/onboarding/views/screens/onboarding_screen.dart';
import 'package:hop_talk/features/setup/views/setup_screen.dart';

class AppRoutes {
  static String onboardingScreen = "/onboardingScreen";
  static String setupScreen = "/setupScreen";
  static String homeScreen = "/homeScreen";

  static List<GetPage> routes =[
    GetPage(name: onboardingScreen, page: () => const OnboardingScreen()),
    GetPage(name: setupScreen, page: () => const SetupScreen()),
    GetPage(name: homeScreen, page: () => const HomeScreen()),
  ];
}