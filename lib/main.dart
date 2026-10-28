import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hop_talk/core/services/storage_service.dart';
import 'package:hop_talk/features/setup/models/user_profile.dart';
import 'package:hop_talk/routes/app_routes.dart';
import 'package:hop_talk/core/utils/bindings/controller_binder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await StorageService.init();
  await Hive.initFlutter();
  Hive.registerAdapter(UserProfileAdapter());
  await Hive.openBox<UserProfile>('userProfileBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isOnboardingComplete = StorageService.isOnboardingComplete;
    final isSetupComplete = StorageService.isSetupComplete;
    return GetMaterialApp(
      title: 'HopTalk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'Inter',
      ),
      initialRoute: !isOnboardingComplete
      ? AppRoutes.onboardingScreen
      : !isSetupComplete
          ? AppRoutes.setupScreen
          : AppRoutes.homeScreen,
      getPages: AppRoutes.routes,
      initialBinding: ControllerBinder(),
    );
  }
}
