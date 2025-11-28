import 'package:flutter/material.dart';
import 'package:hancord_test/core/utils/colors.dart';
import 'package:hancord_test/core/utils/textStyles..dart';

class SelectedServicesSection extends StatelessWidget {
  final List<Map<String, dynamic>> selectedServices;
  final Function(int index) onRemoveService;
  final Function(int index) onDecrementQuantity;
  final Function(int index) onIncrementQuantity;
  final VoidCallback onAddMoreServices;

  const SelectedServicesSection({
    super.key,
    required this.selectedServices,
    required this.onRemoveService,
    required this.onDecrementQuantity,
    required this.onIncrementQuantity,
    required this.onAddMoreServices,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...selectedServices.asMap().entries.map((entry) {
          final index = entry.key;
          final service = entry.value;

          return Padding(
            padding: EdgeInsets.only(
              bottom: index < selectedServices.length - 1 ? 16 : 0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left index + title - Allow full text to be visible
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      Text(
                        '${index + 1}. ',
                        style: getTextStylNunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2B2B2B),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          service['name'],
                          style: getTextStylNunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2B2B2B),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 8),

                // -------------------------------
                //   QUANTITY SELECTOR (DESIGN)
                // -------------------------------
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // MINUS button
                    GestureDetector(
                      onTap: () {
                        if (service['quantity'] > 1) {
                          onDecrementQuantity(index);
                        } else {
                          onRemoveService(index);
                        }
                      },
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: Color(0xFF5F5F5F),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(2),
                            bottomLeft: Radius.circular(2),
                          ),
                        ),
                        child: Icon(
                          Icons.remove,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),

                    // QUANTITY display
                    Container(
                      width: 40,
                      height: 22,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: Color(0xFFECECEC)),
                      child: Text(
                        '${service['quantity']}',
                        style: getTextStylNunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF5F5F5F),
                        ),
                      ),
                    ),

                    // PLUS button
                    GestureDetector(
                      onTap: () {
                        onIncrementQuantity(index);
                      },
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: Color(0xFF5F5F5F),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(2),
                            bottomRight: Radius.circular(2),
                          ),
                        ),
                        child: Icon(Icons.add, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),

                SizedBox(width: 16),

                // PRICE - Right aligned
                Text(
                  '₹${((service['totalPrice'] ?? (service['price'] as num) * (service['quantity'] as int)) as num).toInt()}',
                  style: getTextStylNunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2B2B2B),
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 22),

        // Add more services
        GestureDetector(
          onTap: onAddMoreServices,
          child: Text(
            'Add more Services',
            style: getTextStylNunito(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: PColors.color4FB15E,
            ),
          ),
        ),
      ],
    );
  }
}
