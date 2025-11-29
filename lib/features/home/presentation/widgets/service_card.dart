import 'package:flutter/material.dart';
import 'package:hancord_test/core/utils/colors.dart';
import 'package:hancord_test/core/utils/textStyles..dart';

class ServiceCard extends StatelessWidget {
  final String img;
  final String title;

  const ServiceCard({
    super.key,
    required this.img,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(img, height: 140, width: 160, fit: BoxFit.cover),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: getTextStylNunito(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: PColors.color555555,
            ),
          ),
        ],
      ),
    );
  }
}

