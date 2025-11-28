import 'package:flutter/material.dart';
import 'package:hancord_test/core/utils/colors.dart';
import 'package:hancord_test/core/utils/textStyles..dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Text Field
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search for a service",
                hintStyle: getTextStylNunito(
                  color: PColors.colorB3B3B3,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(
                  left: 20,
                  top: 12,
                  bottom: 12,
                ),
              ),
            ),
          ),
          // Gradient Search Button
          Container(
            margin: EdgeInsets.only(right: 4),
            height: 34,
            width: 35,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff5FCD70), // Lighter green
                  PColors.color4FB15E, // Darker green
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.search, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}
