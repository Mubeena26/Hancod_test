import 'package:flutter/material.dart';
import 'package:hancord_test/core/utils/colors.dart';
import 'package:hancord_test/core/utils/textStyles..dart';
import 'package:hancord_test/features/services/presentation/widgets/custom_painters.dart';

class BillDetailsSection extends StatelessWidget {
  final double kitchenCleaningPrice;
  final double fanCleaningPrice;
  final double taxesAndFees;
  final bool couponApplied;
  final double couponDiscount;
  final double total;
  final VoidCallback onRemoveCoupon;

  const BillDetailsSection({
    super.key,
    required this.kitchenCleaningPrice,
    required this.fanCleaningPrice,
    required this.taxesAndFees,
    required this.couponApplied,
    required this.couponDiscount,
    required this.total,
    required this.onRemoveCoupon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity, // full width
      height: 240, // increased height to fit all details
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Color(0xFFECECEC), // border color
          width: 1, // thickness
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color(0x125C5C5C), // shadow color
            offset: Offset(12, 26),
            blurRadius: 50,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Top-left label
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
                'Bill Details',
                style: getTextStylNunito(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // Bill details content centered
          Positioned(
            left: 16,
            right: 16,
            top: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildBillRow(
                  'Kitchen Cleaning',
                  '₹${kitchenCleaningPrice.toInt()}',
                ),
                const SizedBox(height: 12),
                _buildBillRow(
                  'Fan Cleaning',
                  '₹${fanCleaningPrice.toInt()}',
                ),
                const SizedBox(height: 12),
                _buildBillRow(
                  'Taxes and Fees',
                  '₹${taxesAndFees.toInt()}',
                ),
                if (couponApplied) ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Coupon Code',
                            style: getTextStylNunito(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: onRemoveCoupon,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: PColors.color4FB15E,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '-₹${couponDiscount.toInt()}',
                        style: getTextStylNunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: PColors.color4FB15E,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                // Dashed line
                Container(
                  height: 1,
                  child: CustomPaint(
                    painter: DashedLinePainter(),
                    size: Size.infinite,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: getTextStylNunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '₹${total.toInt()}',
                      style: getTextStylNunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: getTextStylNunito(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xff444444),
          ),
        ),
        Text(
          value,
          style: getTextStylNunito(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xff5F5F5F),
          ),
        ),
      ],
    );
  }
}

