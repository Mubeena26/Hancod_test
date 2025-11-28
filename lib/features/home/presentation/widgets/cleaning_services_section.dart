import 'package:flutter/material.dart';
import 'package:hancord_test/core/utils/colors.dart';
import 'package:hancord_test/core/utils/images.dart';
import 'package:hancord_test/core/utils/textStyles..dart';
import 'package:hancord_test/features/home/presentation/widgets/service_card.dart';
import 'package:hancord_test/features/services/presentation/screens/service_listing_screen.dart';

class CleaningServicesSection extends StatelessWidget {
  const CleaningServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cleaning Services Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Cleaning Services",
              style: getTextStylNunito(
                fontSize: 15,
                color: PColors.color1A1D1F,
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ServiceListingScreen(),
                  ),
                );
              },
              child: Row(
                children: [
                  Text(
                    "See All",
                    style: getTextStylNunito(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: PColors.color4FB15E,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: PColors.color4FB15E,
                    size: 12,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        // Horizontal Cards
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ServiceCard(img: Images.homeCleaning, title: "Home Cleaning"),
              ServiceCard(img: Images.carpetCleaning, title: "Carpet Cleaning"),
              ServiceCard(img: Images.homeCleaning, title: "Sofa Cleaning"),
            ],
          ),
        ),
      ],
    );
  }
}
