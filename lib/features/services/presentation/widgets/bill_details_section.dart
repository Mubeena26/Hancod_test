import 'package:flutter/material.dart';
import 'package:hancord_test/core/utils/colors.dart';
import 'package:hancord_test/core/utils/textStyles..dart';
import 'package:hancord_test/features/services/presentation/widgets/custom_painters.dart';

class BillDetailsSection extends StatelessWidget {
  final double subtotal;
  final List<Map<String, dynamic>> cartItems;
  final double taxesAndFees;
  final bool couponApplied;
  final double couponDiscount;
  final double total;
  final VoidCallback onRemoveCoupon;

  const BillDetailsSection({
    super.key,
    required this.subtotal,
    required this.cartItems,
    required this.taxesAndFees,
    required this.couponApplied,
    required this.couponDiscount,
    required this.total,
    required this.onRemoveCoupon,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate dynamic height based on number of items
    final int itemCount = cartItems.length;
    final double baseHeight = 180.0; // Base height for taxes, coupon, total, etc.
    final double itemHeight = 26.0; // Height per item (14px text + 12px spacing)
    final double calculatedHeight = baseHeight + (itemCount * itemHeight);
    final double containerHeight = calculatedHeight < 240 ? 240 : calculatedHeight;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity, // full width
      height: containerHeight, // dynamic height based on items
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
                // Show individual cart items
                ...cartItems.asMap().entries.map((entry) {
                  final item = entry.value;
                  final itemName = item['name'] as String;
                  final itemQuantity = item['quantity'] as int;
                  final itemPrice = (item['totalPrice'] ?? ((item['price'] as num) * itemQuantity)) as num;
                  return Column(
                    children: [
                      _buildBillRow(
                        itemQuantity > 1 
                            ? '$itemName (x$itemQuantity)' 
                            : itemName,
                        '₹${itemPrice.toInt()}',
                      ),
                      if (entry.key < cartItems.length - 1) const SizedBox(height: 12),
                    ],
                  );
                }).toList(),
                if (cartItems.isNotEmpty) const SizedBox(height: 12),
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

