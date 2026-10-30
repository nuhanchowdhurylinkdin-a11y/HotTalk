import 'package:get/get.dart';
import 'package:flutter/animation.dart';
import 'package:hop_talk/features/home/controller/home_controller.dart';
import 'package:hop_talk/features/mesh_network/controller/mesh_network_controller.dart';

class ScannerController extends GetxController with GetTickerProviderStateMixin {
  late AnimationController animationController;


  final MeshNetworkController meshController = Get.find<MeshNetworkController>();
  final HomeController homeController = Get.find<HomeController>();

  @override
  void onInit() {
    super.onInit();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}