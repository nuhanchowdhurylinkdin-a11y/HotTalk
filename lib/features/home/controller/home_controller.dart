import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hop_talk/features/mesh_network/controller/mesh_network_controller.dart';
import 'package:hop_talk/features/setup/models/user_profile.dart';

class HomeController extends GetxController {

  MeshNetworkController? meshController;

  final Box<UserProfile> _userProfileBox =
  Hive.box<UserProfile>('userProfileBox');

  final Rxn<UserProfile> userProfileData = Rxn<UserProfile>();
  RxString name = ''.obs;


  void loadProfileData () {
    UserProfile? profile = _userProfileBox.get("current");
    userProfileData.value = profile;
  }

  int getDiscoveredDevicesCount() {
    return meshController?.discoveredDevices.length ?? 0;
  }

  int getConnectedDevicesCount() {
    return meshController?.connectedEndpoints.length ?? 0;
  }

  @override
  void onInit() {
    meshController = Get.find<MeshNetworkController>();
    meshController?.initMeshNetwork();
    loadProfileData();
    super.onInit();
  }
}