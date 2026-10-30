import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';

class PermissionController extends GetxController {

  var isPermissionsGranted = false.obs;

  var bluetoothScanGranted = false.obs;
  var bluetoothAdvertiseGranted = false.obs;
  var bluetoothConnectGranted = false.obs;
  var locationGranted = false.obs;
  var nearbyWifiGranted = false.obs;
  var batteryOptimizationDisabled = false.obs;

  @override
  void onInit() {
    checkAndRequestPermissions();
    super.onInit();
  }

  Future<bool> checkAndRequestPermissions() async {
    bluetoothScanGranted.value = await Permission.bluetoothScan.isGranted;
    bluetoothAdvertiseGranted.value = await Permission.bluetoothAdvertise.isGranted;
    bluetoothConnectGranted.value = await Permission.bluetoothConnect.isGranted;
    locationGranted.value = await Permission.location.isGranted;

    var nearbyWifiStatus = await Permission.nearbyWifiDevices.status;
    if (nearbyWifiStatus == PermissionStatus.permanentlyDenied ||
        nearbyWifiStatus == PermissionStatus.restricted) {
      nearbyWifiGranted.value = true;
    } else {
      nearbyWifiGranted.value = await Permission.nearbyWifiDevices.isGranted;
    }

    batteryOptimizationDisabled.value = await Permission.ignoreBatteryOptimizations.isGranted;

    bool allGranted = bluetoothScanGranted.value &&
        bluetoothAdvertiseGranted.value &&
        bluetoothConnectGranted.value &&
        locationGranted.value;

    loc.Location locationService = loc.Location();

    bool isGpsEnabled = await locationService.serviceEnabled();
    if (!isGpsEnabled) {
      isGpsEnabled = await locationService.requestService();
      if (!isGpsEnabled) {
        isPermissionsGranted.value = false;
        return false;
      }
    }

    isPermissionsGranted.value = allGranted && isGpsEnabled;
    return isPermissionsGranted.value;
  }

  Future<void> requestSinglePermission(Permission permission) async {
    PermissionStatus status = await permission.request();

    if (permission == Permission.bluetoothScan) {
      bluetoothScanGranted.value = status.isGranted;
    } else if (permission == Permission.bluetoothAdvertise) {
      bluetoothAdvertiseGranted.value = status.isGranted;
    } else if (permission == Permission.bluetoothConnect) {
      bluetoothConnectGranted.value = status.isGranted;
    } else if (permission == Permission.location) {
      locationGranted.value = status.isGranted;
    } else if (permission == Permission.nearbyWifiDevices) {
      nearbyWifiGranted.value = status.isGranted;
    }

    if (status.isPermanentlyDenied) {
      Get.dialog(
        AlertDialog(
          title: Text("Permission Required"),
          content: Text("Please enable this permission in app settings"),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                openAppSettings();
                Get.back();
              },
              child: Text("Open Settings"),
            ),
          ],
        ),
      );
    }

    await checkAndRequestPermissions();
  }

  Future<void> requestIgnoreBatteryOptimization() async {
    PermissionStatus status = await Permission.ignoreBatteryOptimizations.request();
    batteryOptimizationDisabled.value = status.isGranted;

    if (status.isDenied) {
      Get.dialog(
        AlertDialog(
          title: Text("Battery Optimization"),
          content: Text(
            "For continuous mesh networking, please disable battery optimization. "
            "This keeps HopTalk running in the background to relay messages."
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                openAppSettings();
                Get.back();
              },
              child: Text("Open Settings"),
            ),
          ],
        ),
      );
    }
  }
}
