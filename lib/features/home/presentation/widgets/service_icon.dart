import 'package:flutter/material.dart';
import 'package:hancord_test/core/utils/colors.dart';
import 'package:hancord_test/core/utils/textStyles..dart';

class ServiceIcon extends StatelessWidget {
  final String icon;
  final String title;

  const ServiceIcon({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 62,
          width: 62,
          decoration: BoxDecoration(
            color: PColors.colorF7F7F7,
            shape: BoxShape.circle,
          ),
          child: Center(child: Image.asset(icon, height: 32)),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: getTextStylNunito(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
