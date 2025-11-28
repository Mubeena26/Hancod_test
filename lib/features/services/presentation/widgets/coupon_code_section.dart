import 'package:flutter/material.dart';
import 'package:hancord_test/core/utils/colors.dart';
import 'package:hancord_test/core/utils/textStyles..dart';

class CouponCodeSection extends StatelessWidget {
  final TextEditingController couponController;
  final VoidCallback onApplyCoupon;

  const CouponCodeSection({
    super.key,
    required this.couponController,
    required this.onApplyCoupon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity,
      height: 130, // increased height to fit search bar
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xFFECECEC), // border color
          width: 1, // thickness
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x125C5C5C),
            offset: Offset(12, 26),
            blurRadius: 50,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Top-left action button
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              height: 48,
              width: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xFFF0F0F0),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Text(
                'Coupon Code',
                style: getTextStylNunito(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // Search bar below Coupon Code
          Positioned(
            left: 0,
            right: 0,
            top: 60, // space below the Coupon Code button
            child: Container(
              height: 48,
              margin: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Color(0xFFECECEC), // border color
                  width: 1, // border thickness
                ),
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
                      controller: couponController,
                      decoration: InputDecoration(
                        hintText: "Enter Coupon Code",
                        hintStyle: getTextStylNunito(
                          color: PColors.colorB3B3B3,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
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
                  GestureDetector(
                    onTap: onApplyCoupon,
                    child: Container(
                      margin: EdgeInsets.only(right: 0),
                      height: 45,
                      width: 95,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF5FCD70), // lighter green
                            Color(0xFF0E826B), // darker green
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          'Apply',
                          style: getTextStylNunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

