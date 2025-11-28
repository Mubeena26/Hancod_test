import 'package:flutter/material.dart';
import 'package:hancord_test/core/utils/textStyles..dart';

class CartSummaryWidget extends StatelessWidget {
  final int totalItems;
  final double totalPrice;
  final VoidCallback onViewCart;

  const CartSummaryWidget({
    super.key,
    required this.totalItems,
    required this.totalPrice,
    required this.onViewCart,
  });

  @override
  Widget build(BuildContext context) {
    if (totalItems == 0) return SizedBox.shrink();

    final double boxWidth = MediaQuery.of(context).size.width * 0.88;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // WHITE CONTAINER
        Container(
          width: boxWidth,
          padding: const EdgeInsets.fromLTRB(
            16,
            14,
            16,
            60,
          ), // ↓ reduced height
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
              '$totalItems items | ₹${totalPrice.toStringAsFixed(0)}',
              style: getTextStylNunito(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xff444444),
              ),
            ),
          ),
        ),

        // RED BUTTON CONTAINER
        Positioned(
          bottom: 0,
          child: GestureDetector(
            onTap: onViewCart,
            child: Container(
              width: boxWidth,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Color(0xFFFF6B4A),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    "VIEW CART",
                    style: getTextStylNunito(
                      fontSize: 14,
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

