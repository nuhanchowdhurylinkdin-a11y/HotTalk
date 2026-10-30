import 'package:flutter/material.dart';

class MeshStatus extends StatelessWidget {
  const MeshStatus({super.key,
    this.dotColor = Colors.blue,
    required this.text
  });

  final Color dotColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      height: 24,
      decoration: BoxDecoration(
        color: Color(0xFFF0EDEF),
        borderRadius: BorderRadius.circular(200),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // dot status indicator
          Container(
            height: 7,
            width: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: dotColor,
            ),
          ),

          SizedBox(width: 5,),

          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}
