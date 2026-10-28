import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/state_manager.dart';
import 'package:get/utils.dart';
import 'package:hop_talk/core/common/widgets/submit_button.dart';
import 'package:hop_talk/core/utils/constants/colors.dart';
import 'package:hop_talk/features/setup/controller/setup_controller.dart';

class SetupScreen extends GetView<SetupController> {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 40),
              Text(
                "Set Up Your Profile",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10),
              Text(
                "Choose how nearby peers recognize you on the mesh network.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF454836),
                  fontWeight: FontWeight.w500,
                ),
              ),

              SizedBox(height: 35),

              // display image
              SizedBox(
                width: 96,
                height: 96,
                child: Stack(
                  children: [
                    // picked avatar or image
                    Obx(() {
                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            width: 6,
                          ),
                        ),
                        child: Container(
                          height: 96,
                          width: 96,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 5),
                          ),
                          child: ClipOval(
                            child: controller.selectedAvatar.isNotEmpty
                                ? SvgPicture.asset(
                                    controller.selectedAvatar.value,
                                  )
                                : controller.profileImagePath.isNotEmpty
                                ? Image.file(
                                    File(controller.profileImagePath.value),
                                    fit: BoxFit.cover,
                                  )
                                : Icon(Icons.person),
                          ),
                        ),
                      );
                    }),

                    // pick image from galary
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Material(
                        elevation: 7,
                        borderRadius: BorderRadius.all(Radius.circular(300)),
                        child: InkWell(
                          onTap: controller.pickImageFromGallery,
                          child: Container(
                            height: 32,
                            width: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                            child: Icon(Icons.camera_alt_outlined, size: 17),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

               SizedBox(height: 15),

              // name section
              TextField(
                controller: controller.nameController,
                textAlign: TextAlign.center,
                cursorColor: AppColors.neutral,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.neutral,
                ),
                decoration: InputDecoration(
                  suffix: Icon(Icons.edit, color: AppColors.neutral.withValues(alpha: 0.6),),
                  hintText: "Enter Your Name",
                  hintStyle: const TextStyle(fontSize: 22, color: Colors.grey),

                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.5),
                  ),

                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.secondary),
                  ),
                ),
              ).paddingSymmetric(horizontal: 25),

               SizedBox(height: 25),

              // avatars
              Column(
                children: [
                  // Swipeable avatar pages
                  SizedBox(
                    height: 200,
                    child: PageView.builder(
                      controller: controller.avatarPageController,
                      itemCount: controller.avatarPageCount,
                      onPageChanged: (index) {
                        controller.currentAvatarPage.value = index;
                      },
                      itemBuilder: (context, pageIndex) {
                        final pageAvatars = controller.avatarsForPage(
                          pageIndex,
                        );

                        return GridView.builder(
                          padding: const EdgeInsets.all(12),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: pageAvatars.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1,
                              ),
                          itemBuilder: (context, index) {
                            final avatar = pageAvatars[index];

                            return Obx(() {
                              final isActive =
                                  controller.selectedAvatar.value == avatar;

                              return GestureDetector(
                                onTap: () => controller.selectAvatar(avatar),
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isActive
                                          ? AppColors.primary
                                          : Colors.transparent,
                                      width: 3,
                                    ),
                                  ),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      ClipOval(
                                        child: SvgPicture.asset(
                                          avatar,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      if (isActive)
                                        const Align(
                                          alignment: Alignment.bottomRight,
                                          child: CircleAvatar(
                                            radius: 9,
                                            backgroundColor:
                                                AppColors.secondary,
                                            child: Icon(
                                              Icons.check,
                                              size: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            });
                          },
                        );
                      },
                    ),
                  ),


                  // Page indicator dots
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(controller.avatarPageCount, (
                        index,
                      ) {
                        final isActive =
                            controller.currentAvatarPage.value == index;

                        return GestureDetector(
                          onTap: () {
                            controller.avatarPageController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: isActive ? 12 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isActive
                                  ? AppColors.secondary
                                  : Colors.grey.shade300,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 35,),
            

            SubmitButton(title: "Done", callback: controller.saveProfile)
            
            ],
          ).paddingSymmetric(horizontal: 16),
        ),
      ),
    );
  }
}
