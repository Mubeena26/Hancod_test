import 'package:flutter/material.dart';
import 'package:hancord_test/core/utils/images.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage(Images.homefirst),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
