import 'package:flutter/material.dart';
import 'package:hancord_test/core/utils/textStyles..dart';

class GrandTotalCard extends StatelessWidget {
  final double total;
  final VoidCallback onBookSlot;

  const GrandTotalCard({
    super.key,
    required this.total,
    required this.onBookSlot,
  });

  @override
  Widget build(BuildContext context) {
    final double boxWidth = MediaQuery.of(context).size.width * 0.88;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // WHITE CONTAINER with Grand Total
        Container(
          width: boxWidth,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 60),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Color(0x4D000000),
                blurRadius: 10,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Center(
            child: Text(
              'Grand Total | ₹${total.toInt()}',
              style: getTextStylNunito(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff444444),
              ),
            ),
          ),
        ),
        // BOOK SLOT BUTTON
        Positioned(
          bottom: 0,
          child: GestureDetector(
            onTap: onBookSlot,
            child: Container(
              width: boxWidth,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF5FCD70), // lighter green
                    Color(0xFF0E826B), // darker green
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    "BOOK SLOT",
                    style: getTextStylNunito(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    right: 16,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}


