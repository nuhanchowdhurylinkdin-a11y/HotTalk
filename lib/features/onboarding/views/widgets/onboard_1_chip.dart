import 'package:flutter/material.dart';
import 'package:hop_talk/core/utils/constants/colors.dart';
import 'package:hop_talk/features/onboarding/views/widgets/onboarding_chip.dart';

class Onboard1Chip extends StatelessWidget {
  const Onboard1Chip({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: OnboardChip(
            title: "Nearby phones mesh",
            dotColor: AppColors.neutral,
          ),
        ),

        SizedBox(width: 15),

        Expanded(
          child: OnboardChip(
            title: "Long-range LoRa",
            dotColor: Color(0xFF767964),
          ),
        ),
      ],
    );
  }
}
