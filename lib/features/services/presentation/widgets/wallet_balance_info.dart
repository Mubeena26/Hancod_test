import 'package:flutter/material.dart';
import 'package:hancord_test/core/utils/textStyles..dart';

class WalletBalanceInfo extends StatelessWidget {
  const WalletBalanceInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Color(0xFF5FCD70), // lighter green
                Color(0xFF0E826B), // darker green
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 14),
        ),
        const SizedBox(width: 10),
        Text(
          'Your wallet balance is ₹125, you can redeem ₹10\nin this order.',
          style: getTextStylNunito(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xff929292),
          ),
        ),
      ],
    );
  }
}

