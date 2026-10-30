import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hop_talk/features/home/controller/home_controller.dart';
import 'package:location/location.dart' as loc;
import 'package:nearby_connections/nearby_connections.dart';
import 'package:permission_handler/permission_handler.dart';

class MeshNetworkController extends GetxController {
  @override
  void onInit() {
    checkAndRequestPermissions();
    super.onInit();
  }

  HomeController get _homeController => Get.find<HomeController>();

  final String serviceId = "com.hoptalk.mesh";
  final Strategy strategy = Strategy.P2P_CLUSTER;

  var isPermissionsGranted = false.obs;
  var isAdvertising = false.obs;
  var isDiscovering = false.obs;

  // Individual permission states
  var bluetoothScanGranted = false.obs;
  var bluetoothAdvertiseGranted = false.obs;
  var bluetoothConnectGranted = false.obs;
  var locationGranted = false.obs;
  var nearbyWifiGranted = false.obs;
  var batteryOptimizationDisabled = false.obs;

  var connectedEndpoints = <String, String>{}.obs; // connected devices
  var discoveredDevices = <String, String>{}.obs; // discovered devices
  var blockedDevices = <String>[].obs; // blocked devices

  final Set<String> _processedMessageIds = {};
  final int _maxCacheSize = 200;

  Future<bool> checkAndRequestPermissions() async {
    bluetoothScanGranted.value = await Permission.bluetoothScan.isGranted;
    bluetoothAdvertiseGranted.value =
        await Permission.bluetoothAdvertise.isGranted;
    bluetoothConnectGranted.value = await Permission.bluetoothConnect.isGranted;
    locationGranted.value = await Permission.location.isGranted;

    var nearbyWifiStatus = await Permission.nearbyWifiDevices.status;
    if (nearbyWifiStatus == PermissionStatus.permanentlyDenied ||
        nearbyWifiStatus == PermissionStatus.restricted) {
      nearbyWifiGranted.value = true;
    } else {
      nearbyWifiGranted.value = await Permission.nearbyWifiDevices.isGranted;
    }

    batteryOptimizationDisabled.value =
        await Permission.ignoreBatteryOptimizations.isGranted;

    bool allGranted =
        bluetoothScanGranted.value &&
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

  void _onConnectionInitiated(String endpointId, ConnectionInfo info) {
    Nearby().acceptConnection(
      endpointId,
      onPayLoadRecieved: (String endpointId, Payload payload) {
        // waiting for receive messages
        if (payload.type == PayloadType.BYTES) {
          String message = String.fromCharCodes(payload.bytes!);
          print("Received mesh message: $message");
          // hive database pass
        }
      },
    );
  }

  Future<void> startAdvertising(String userName) async {
    try {
      bool result = await Nearby().startAdvertising(
        userName,
        strategy,
        serviceId: serviceId,
        onConnectionInitiated: (String endpointId, ConnectionInfo info) {
          _onConnectionInitiated(endpointId, info);
        },
        onConnectionResult: (String endpointId, Status status) {
          if (status == Status.CONNECTED) {
            connectedEndpoints[endpointId] = endpointId;
            update();
          } else {
            connectedEndpoints.remove(endpointId);
          }
        },
        onDisconnected: (String endpointId) {
          connectedEndpoints.remove(endpointId);
          update();
        },
      );
      isAdvertising.value = result;
    } catch (e) {
      print("Error starting advertising: $e");
    }
  }

  Future<void> startDiscovery(String userName) async {
    try {
      bool result = await Nearby().startDiscovery(
        userName,
        strategy,
        serviceId: serviceId,
        onEndpointFound: (String endpointId, String name, String serviceId) {
          discoveredDevices[endpointId] = name;

          if (!blockedDevices.contains(endpointId)) {
            _requestConnection(userName, endpointId);
          } else {
            print("Device $name is blocked, skipping connection");
          }
        },
        onEndpointLost: (String? endpointId) {
          if (endpointId != null) {
            discoveredDevices.remove(endpointId);
            connectedEndpoints.remove(endpointId);
            update();
          }
        },
      );
      isDiscovering.value = result;
    } catch (e) {
      print("Error starting discovery: $e");
    }
  }

  void _requestConnection(String localUserName, String endpointId) async {
    try {
      await Nearby().requestConnection(
        localUserName,
        endpointId,
        onConnectionInitiated: (id, info) => _onConnectionInitiated(id, info),
        onConnectionResult: (id, status) {
          if (status == Status.CONNECTED) {
            connectedEndpoints[id] = endpointId;
            update();
          }
        },
        onDisconnected: (id) {
          connectedEndpoints.remove(id);
          update();
        },
      );
    } catch (e) {
      print("Error requesting connection: $e");
    }
  }

  void startMeshNode(String localUserName) async {
    await startAdvertising(localUserName);
    await startDiscovery(localUserName);
  }

  Future<void> initMeshNetwork() async {
    bool hasPermission = await checkAndRequestPermissions();
    if (hasPermission) {
      await Nearby().stopAdvertising();
      await Nearby().stopDiscovery();
      await Nearby().stopAllEndpoints();

      await Future.delayed(Duration(milliseconds: 500));

      startMeshNode(_homeController.userProfileData.value!.name);
    } else {
      Get.snackbar(
        "Permission Required",
        "Bluetooth, Location & Nearby permissions are required for offline mesh.",
      );
    }
  }

  // Request a single permission and update its state
  Future<void> requestSinglePermission(Permission permission) async {
    PermissionStatus status = await permission.request();

    // Update the specific state
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

    // Handle permanent denial
    if (status.isPermanentlyDenied) {
      Get.dialog(
        AlertDialog(
          title: Text("Permission Required"),
          content: Text("Please enable this permission in app settings"),
          actions: [
            TextButton(onPressed: () => Get.back(), child: Text("Cancel")),
            TextButton(
              onPressed: () {
                openAppSettings(); // Opens system settings
                Get.back();
              },
              child: Text("Open Settings"),
            ),
          ],
        ),
      );
    }

    // Re-check if all permissions are granted
    await checkAndRequestPermissions();
  }

  // Request to ignore battery optimization
  Future<void> requestIgnoreBatteryOptimization() async {
    PermissionStatus status = await Permission.ignoreBatteryOptimizations
        .request();
    batteryOptimizationDisabled.value = status.isGranted;

    if (status.isDenied) {
      // User denied ---> show explanation

      Get.dialog(
        AlertDialog(
          title: Text("Battery Optimization"),
          content: Text(
            "For continuous mesh networking, please disable battery optimization. "
            "This keeps HopTalk running in the background to relay messages.",
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: Text("Cancel")),
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

  void _handleIncomingPayload(String senderEndpointId, Uint8List rawBytes) {
    String jsonString = utf8.decode(rawBytes);
    Map<String, dynamic> packet = jsonDecode(jsonString);

    String messageId = packet['messageId'];

    if (_processedMessageIds.contains(messageId)) {
      return;
    }

    _processedMessageIds.add(messageId);
    if (_processedMessageIds.length > _maxCacheSize) {
      _processedMessageIds.remove(_processedMessageIds.first);
    }

    String targetUserId = packet['targetId'];
    bool isForLoraModule = packet['isLora'];
    String currentUserId =
        _homeController.userProfileData.value!.userId; // current user id

    if (targetUserId == currentUserId) {
      print("Message Received for ME: ${packet['body']}");
      // TODO: Nee to add the message in hive and in ui
      return;
    }

    bool isConnectedToESP32 = true;
    if (isConnectedToESP32 && isForLoraModule) {
      // if ESP32 is connected and if the message is for LORA Gateway
      sendToEsp32LoraGateway(jsonString);
    } else {
      // if the message is for another just hop and push forword
      relayMessageToMesh(senderEndpointId, rawBytes);
    }
  }

  // mesh to all connected phones
  void relayMessageToMesh(String originEndpointId, Uint8List rawBytes) {
    Uint8List safeBytes = Uint8List.fromList(rawBytes);

    connectedEndpoints.forEach((endpointId, name) {
      if (endpointId != originEndpointId) {
        Nearby().sendBytesPayload(endpointId, safeBytes);
      }
    });
  }


  void sendToEsp32LoraGateway(String payloadString) {
    print("Forwarded to LoRa via ESP32: $payloadString");
  }

  void broadcastMessage(String targetUserId, String messageBody, bool isLora) {
    Map<String, dynamic> packet = {
      "isLora": isLora,
      "messageId": DateTime.now().millisecondsSinceEpoch.toString(),
      "senderId": _homeController.userProfileData.value!.userId,
      "targetId": targetUserId,
      "body": messageBody,
      "hopCount": 0,
    };

    // convert sting to byte for standard Uint8List
    List<int> encodedBytes = utf8.encode(jsonEncode(packet));
    Uint8List bytes = Uint8List.fromList(encodedBytes);

    connectedEndpoints.forEach((endpointId, name) {
      Nearby().sendBytesPayload(endpointId, bytes);
    });
  }

  void blockDevice(String endpointId) {
    if (!blockedDevices.contains(endpointId)) {
      blockedDevices.add(endpointId);

      if (connectedEndpoints.containsKey(endpointId)) {
        Nearby().disconnectFromEndpoint(endpointId);
        connectedEndpoints.remove(endpointId);
      }
    }
  }

  void unblockDevice(String endpointId) {
    blockedDevices.remove(endpointId);
  }

  void manualConnectToDevice(String endpointId) {
    String userName = _homeController.userProfileData.value!.name;
    _requestConnection(userName, endpointId);
  }

  @override
  void onClose() {
    Nearby().stopAdvertising();
    Nearby().stopDiscovery();
    Nearby().stopAllEndpoints();
    super.onClose();
  }
}
