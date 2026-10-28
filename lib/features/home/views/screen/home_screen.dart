import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hop_talk/core/utils/constants/colors.dart';
import 'package:hop_talk/features/home/controller/home_controller.dart';
import 'package:hop_talk/features/home/views/widgets/mesh_status.dart';
import 'package:hop_talk/features/setup/models/user_profile.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Chats",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(width: 12,),

            MeshStatus()
          ],
        ),

        actions: [
          Obx(() {
            return CircleAvatar(
              radius: 40,
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: _buildProfileImage(controller.userProfileData.value),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildProfileImage(UserProfile? profile) {
    if (profile!.imagePath.isNotEmpty) {
      if (profile.imagePath.isNotEmpty) {
        return Image.file(
          File(profile.imagePath),
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.person, size: 32, color: Colors.grey);
          },
        );
      }
    } else if (profile.avatar.isNotEmpty) {
      return SvgPicture.asset(
        profile.avatar,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
      );
    }
    return const Icon(Icons.person, size: 32, color: Colors.grey);
  }
}
