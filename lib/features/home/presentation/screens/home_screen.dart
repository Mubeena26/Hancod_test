import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hancord_test/core/utils/colors.dart';
import 'package:hancord_test/features/home/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:hancord_test/features/home/presentation/widgets/home_banner.dart';
import 'package:hancord_test/features/home/presentation/widgets/home_header.dart';
import 'package:hancord_test/features/home/presentation/widgets/home_search_bar.dart';
import 'package:hancord_test/features/home/presentation/widgets/available_services_section.dart';
import 'package:hancord_test/features/home/presentation/widgets/cleaning_services_section.dart';
import 'package:hancord_test/features/home/presentation/providers/home_navigation_provider.dart';
import 'package:hancord_test/features/profile/presentation/screens/profile_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigationState = ref.watch(homeNavigationProvider);
    final selectedIndex = navigationState.selectedIndex;

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
          ref.read(homeNavigationProvider.notifier).setSelectedIndex(index);

          // Handle navigation based on selected index
          if (index == 2) {
            // Navigate to Profile/Account screen
            Navigator.of(context)
                .push(
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                )
                .then((_) {
                  // Reset to Home when returning from Profile screen
                  ref.read(homeNavigationProvider.notifier).setSelectedIndex(0);
                });
          }
          // Add other navigation cases as needed (index 0 = Home, index 1 = Bookings)
        },
      ),
    );
  }
}
