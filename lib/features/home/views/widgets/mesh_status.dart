import 'package:flutter/material.dart';

class MeshStatus extends StatelessWidget {
  const MeshStatus({super.key});

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
              color: Colors.blue,
            ),
          ),

          SizedBox(width: 5,),

          Text(
            "Mesh Active",
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
