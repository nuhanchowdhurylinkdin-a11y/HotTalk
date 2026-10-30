import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hop_talk/core/utils/constants/colors.dart';
import 'package:hop_talk/features/home/views/widgets/mesh_status.dart';
import 'package:hop_talk/features/permission/controller/permission_controller.dart';
import 'package:hop_talk/routes/app_routes.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionScreen extends StatelessWidget {
  const PermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PermissionController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        actions: [
          MeshStatus(
            text: "Setup Mode",
            dotColor: Color(0xFF767964),
          ).paddingOnly(right: 10),
        ],
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Text(
                "Let's get you connected",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),

              Text(
                "Offline Messenger requires device hardware access to route peer-to-peer packets without cellular data.",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Color(0xFF454836),
                ),
              ),

              SizedBox(height: 25),

              Obx(() {
                return _buildPermissionTile(
                  icon: Icons.bluetooth_searching,
                  title: "Nearby devices",
                  subtitle: "To find phones around you",
                  isEnabled:
                      controller.bluetoothScanGranted.value &&
                      controller.bluetoothAdvertiseGranted.value &&
                      controller.bluetoothConnectGranted.value,
                  onTap: () async {
                    await controller.requestSinglePermission(
                      Permission.bluetoothScan,
                    );
                    await controller.requestSinglePermission(
                      Permission.bluetoothAdvertise,
                    );
                    await controller.requestSinglePermission(
                      Permission.bluetoothConnect,
                    );
                  },
                );
              }),

              SizedBox(height: 15),

              Obx(() {
                return _buildPermissionTile(
                  icon: Icons.navigation_rounded,
                  rotate: 0.7,
                  title: "Location",
                  subtitle: "Required by Android for offline",
                  isEnabled: controller.locationGranted.value,
                  onTap: () =>
                      controller.requestSinglePermission(Permission.location),
                );
              }),

              SizedBox(height: 15),

              Obx(() {
                return _buildPermissionTile(
                  icon: Icons.wifi,
                  rotate: 0.8,
                  title: "Nearby WiFi Devices",
                  subtitle: "Optional - Android 13+",
                  isEnabled: controller.nearbyWifiGranted.value,
                  onTap: () => controller.requestSinglePermission(
                    Permission.nearbyWifiDevices,
                  ),
                );
              }),

              SizedBox(height: 15),

              Obx(() {
                return _buildPermissionTile(
                  icon: Icons.battery_charging_full,
                  title: "Battery",
                  subtitle: "Keep running in background",
                  isEnabled: controller.batteryOptimizationDisabled.value,
                  onTap: () => controller.requestIgnoreBatteryOptimization(),
                );
              }),

              SizedBox(height: 16),

              Obx(() {
                return !controller.batteryOptimizationDisabled.value
                    ? Text(
                        "⚠️ Battery optimization may limit background messaging",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      )
                    : SizedBox.shrink();
              }),

              SizedBox(height: 24),

              Obx(() {
                bool allCriticalGranted = controller.bluetoothScanGranted.value &&
                    controller.bluetoothAdvertiseGranted.value &&
                    controller.bluetoothConnectGranted.value &&
                    controller.locationGranted.value;

                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: allCriticalGranted
                        ? () {
                            Get.offAllNamed(AppRoutes.homeScreen);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.secondary,
                      disabledBackgroundColor: Colors.grey[300],
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                );
              }),

              SizedBox(height: 16),

              Text(
                "Grant all required permissions to proceed",
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF767964),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ).paddingSymmetric(horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildPermissionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isEnabled,
    required VoidCallback onTap,
    double? rotate = 0,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,

      leading: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFFF0EDEF),
        ),
        alignment: Alignment.center,
        child: Transform.rotate(
          angle: rotate ?? 0,
          child: Icon(icon, color: const Color(0xFF454836)),
        ),
      ),
      title: Text(
        title,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        subtitle,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      ),
      trailing: isEnabled
          ? Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(Icons.check, size: 22, color: AppColors.secondary),
            )
          : ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF0EDEF),
                foregroundColor: AppColors.neutral,
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              child: Text(
                "Allow",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
    );
  }
}
