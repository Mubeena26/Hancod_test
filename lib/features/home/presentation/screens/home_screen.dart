import 'package:flutter/material.dart';
import 'package:hancord_test/core/utils/colors.dart';
import 'package:hancord_test/features/home/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:hancord_test/features/home/presentation/widgets/home_banner.dart';
import 'package:hancord_test/features/home/presentation/widgets/home_header.dart';
import 'package:hancord_test/features/home/presentation/widgets/home_search_bar.dart';
import 'package:hancord_test/features/home/presentation/widgets/available_services_section.dart';
import 'package:hancord_test/features/home/presentation/widgets/cleaning_services_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PColors.colorF8F8F8,

      // ----------------------------
      //       MAIN HOME CONTENT
      // ----------------------------
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeHeader(),
              const HomeBanner(),
              const SizedBox(height: 18),
              const HomeSearchBar(),
              const SizedBox(height: 24),
              const AvailableServicesSection(),
              const SizedBox(height: 20),
              const CleaningServicesSection(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),

      // ----------------------------
      //     CUSTOM BOTTOM NAV BAR
      // ----------------------------
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}
