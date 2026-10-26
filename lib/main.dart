import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hop_talk/routes/app_routes.dart';
import 'package:hop_talk/core/utils/bindings/controller_binder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'Inter'
      ),
      
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.onboardingScreen,
          getPages: AppRoutes.routes,
          initialBinding: ControllerBinder(),
        );
      },
    );
  }
}

