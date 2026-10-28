import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hop_talk/features/setup/models/user_profile.dart';

class HomeController extends GetxController {

  final Box<UserProfile> _userProfileBox =
  Hive.box<UserProfile>('userProfileBox');

  final Rxn<UserProfile> userProfileData = Rxn<UserProfile>();
  RxString name = ''.obs;


  void loadProfileData () {
    UserProfile? profile = _userProfileBox.get("current");
    userProfileData.value = profile;
  }

  @override
  void onInit() {
    loadProfileData();
    super.onInit();
  }
}