import 'package:flutter/material.dart';
import 'package:hancord_test/core/utils/colors.dart';
import 'package:hancord_test/core/utils/textStyles..dart';
import 'package:hancord_test/features/services/domain/entitities/service_model.dart';

class ServiceCardWidget extends StatelessWidget {
  final ServiceModel service;
  final bool isInCart;
  final int quantity;
  final VoidCallback onAddToCart;
  final VoidCallback onIncrementQuantity;
  final VoidCallback onDecrementQuantity;

  const ServiceCardWidget({
    super.key,
    required this.service,
    required this.isInCart,
    required this.quantity,
    required this.onAddToCart,
    required this.onIncrementQuantity,
    required this.onDecrementQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color(0x125C5C5C), // same as #5C5C5C12
            offset: Offset(12, 26),
            blurRadius: 50,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Color(0xFFF5F5F5),
                    child: Image.asset(
                      service.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Color(0xFFE5E5E5),
                          child: Icon(Icons.image, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Service Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rating
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '(${service.rating}/5) ${service.orderCount} Orders',
                            style: getTextStylNunito(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF6B6B6B),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Service Name
                      Text(
                        service.name,
                        style: getTextStylNunito(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Duration
                      Text(
                        service.duration,
                        style: getTextStylNunito(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF9B9B9B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Price
                      Text(
                        '₹ ${service.price.toStringAsFixed(2)}',
                        style: getTextStylNunito(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Action button positioned at bottom-right with one-sided rounded corners
          Positioned(
            right: 0,
            bottom: 0,
            child: _ServiceActionButton(
              isInCart: isInCart,
              quantity: quantity,
              onAddToCart: onAddToCart,
              onIncrementQuantity: onIncrementQuantity,
              onDecrementQuantity: onDecrementQuantity,
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceActionButton extends StatelessWidget {
  final bool isInCart;
  final int quantity;
  final VoidCallback onAddToCart;
  final VoidCallback onIncrementQuantity;
  final VoidCallback onDecrementQuantity;

  const _ServiceActionButton({
    required this.isInCart,
    required this.quantity,
    required this.onAddToCart,
    required this.onIncrementQuantity,
    required this.onDecrementQuantity,
  });

  @override
  Widget build(BuildContext context) {
    const double actionButtonHeight = 48; // SAME SIZE FOR BOTH BUTTONS

    if (isInCart) {
      return Container(
        height: actionButtonHeight,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: onDecrementQuantity,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                alignment: Alignment.center,
                child: Icon(Icons.remove, color: PColors.color4FB15E, size: 20),
              ),
            ),
            Text(
              '$quantity',
              style: getTextStylNunito(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: PColors.color4FB15E,
              ),
            ),
            GestureDetector(
              onTap: onIncrementQuantity,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                alignment: Alignment.center,
                child: Icon(Icons.add, color: PColors.color4FB15E, size: 20),
              ),
            ),
          ],
        ),
      );
    }

    // ADD BUTTON
    return GestureDetector(
      onTap: onAddToCart,
      child: Container(
        height: actionButtonHeight,
        padding: const EdgeInsets.symmetric(horizontal: 28),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF5FCD70), // Lighter green
              Color(0xFF0E826B),
            ], // Lighter green]],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add',
              style: getTextStylNunito(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 6),
            Icon(Icons.add, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }
}

