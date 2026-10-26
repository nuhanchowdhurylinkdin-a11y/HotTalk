import 'package:flutter/material.dart';
import 'package:hop_talk/core/utils/constants/colors.dart';

class SubmitButton extends StatelessWidget {
  const new({super.key, required this.title,this.color = AppColors.primary, required this.callback});

  final String title;
  final Color color;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: AppColors.primary,
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.neutral
          ),
        ),
      ),
    );
  }
}