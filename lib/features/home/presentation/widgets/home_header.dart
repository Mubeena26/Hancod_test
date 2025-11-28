import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hancord_test/core/utils/svgs.dart';
import 'package:hancord_test/core/utils/textStyles..dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        // 👋 Emoji - Centered
        const Center(child: Text("👋", style: TextStyle(fontSize: 28))),
        const SizedBox(height: 4),
        // Address + Checkmark + Cart
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // LEFT SIDE → Address + Check Icon
            Padding(
              padding: EdgeInsetsGeometry.only(right: 14, left: 14),
              child: Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        "406, Skyline Park Dale, MM Road...",
                        overflow: TextOverflow.ellipsis,
                        style: getTextStylNunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff929292),
                        ),
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 12),
            // RIGHT SIDE → Cart with Shadow
            Transform.translate(
              offset: Offset(0, -10),
              child: Container(
                height: 50,
                width: 50,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: SvgPicture.asset(Svgs.cart),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
