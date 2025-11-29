import 'package:flutter/material.dart';
import 'package:hancord_test/core/utils/colors.dart';
import 'package:hancord_test/core/utils/images.dart';
import 'package:hancord_test/core/utils/textStyles..dart';
import 'package:hancord_test/features/home/presentation/widgets/service_icon.dart';

class AvailableServicesSection extends StatelessWidget {
  const AvailableServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Available Services",
            style: getTextStylNunito(
              fontSize: 15,
              color: PColors.color1A1D1F,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ServiceIcon(icon: Images.cleaning, title: "Cleaning"),
              ServiceIcon(icon: Images.firstDisposal, title: "Waste Disposal"),
              ServiceIcon(icon: Images.plumbing, title: "Plumbing"),
              ServiceIcon(icon: Images.plumbing, title: "Plumbing"),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ServiceIcon(icon: Images.cleaning, title: "Cleaning"),
              ServiceIcon(icon: Images.firstDisposal, title: "Waste Disposal"),
              ServiceIcon(icon: Images.plumbing, title: "Plumbing"),
              // Arrow + See all
              Column(
                children: [
                  Container(
                    height: 62,
                    width: 62,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: PColors.colorF7F7F7,
                      border: Border.all(color: PColors.colorECECEC),
                    ),
                    child: Center(
                      child: Image.asset(
                        Images.arrow,
                        height: 24,
                        width: 24,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "See All",
                    style: getTextStylNunito(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: PColors.color4FB15E,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

