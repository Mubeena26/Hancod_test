import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hancord_test/core/utils/colors.dart';
import 'package:hancord_test/core/utils/svgs.dart';
import 'package:hancord_test/core/utils/textStyles..dart';
import 'package:hancord_test/features/auth/presentation/providers/auth_providers.dart';
import 'package:hancord_test/features/auth/presentation/screens/login_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: authState.when(
          data: (user) {
            if (user == null) {
              // If user is not logged in, navigate to login
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              });
              return const SizedBox.shrink();
            }

            // Extract user name and phone
            final displayName = user.displayName ?? 'User';
            final phoneNumber = user.phoneNumber ?? '';

            // Get initials for avatar
            final initials = _getInitials(displayName);

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // Title: My Account
                    Text(
                      'My Account',
                      style: getTextStylNunito(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff2E2E2E),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Profile Section with Avatar, Name and Phone
                    Row(
                      children: [
                        // Avatar with initials
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF5FCD70), // Lighter green
                                Color(0xFF0E826B), // Lighter green
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              initials,
                              style: getTextStylNunito(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Name and Phone
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                displayName,
                                style: getTextStylNunito(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff444444),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                phoneNumber.isNotEmpty
                                    ? phoneNumber
                                    : 'No phone number',
                                style: getTextStylNunito(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff444444),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Wallet Section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD7FFF0), // Light green
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Wallet',
                            style: getTextStylNunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF5FCD70),
                            ),
                          ),

                          /// WHITE SMALL CONTAINER FOR BALANCE
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Balance - 125',
                              style: getTextStylNunito(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF5FCD70),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Menu Options
                    _buildMenuOption(
                      icon: Svgs.editprofile,
                      title: 'Edit Profile',
                      onTap: () {
                        // TODO: Navigate to edit profile screen
                      },
                    ),

                    const SizedBox(height: 12),

                    _buildMenuOption(
                      icon: Svgs.saved,
                      title: 'Saved Address',
                      onTap: () {
                        // TODO: Navigate to saved address screen
                      },
                    ),

                    const SizedBox(height: 12),

                    _buildMenuOption(
                      icon: Svgs.terms,
                      title: 'Terms & Conditions',
                      onTap: () {
                        // TODO: Navigate to terms & conditions screen
                      },
                    ),

                    const SizedBox(height: 12),

                    _buildMenuOption(
                      icon: Svgs.terms,
                      title: 'Privacy Policy',
                      onTap: () {
                        // TODO: Navigate to privacy policy screen
                      },
                    ),

                    const SizedBox(height: 12),

                    _buildMenuOption(
                      icon: Svgs.refer,
                      title: 'Refer a friend',
                      onTap: () {
                        // TODO: Navigate to refer a friend screen
                      },
                    ),

                    const SizedBox(height: 12),

                    _buildMenuOption(
                      icon: Svgs.customer,
                      title: 'Customer Support',
                      onTap: () {
                        // TODO: Navigate to customer support screen
                      },
                    ),

                    const SizedBox(height: 12),

                    _buildMenuOption(
                      icon: Svgs.logout,
                      title: 'Log Out',
                      onTap: () => _handleLogout(context, ref),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text(
              'Error loading profile: $error',
              style: getTextStyleRfDewi(fontSize: 14, color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'U';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return name[0].toUpperCase();
  }

  Widget _buildMenuOption({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: PColors.colorECECEC, width: 1),
        ),
        child: Row(
          children: [
            SvgPicture.asset(icon),
            const SizedBox(width: 32),
            Text(
              title,
              style: getTextStylNunito(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff444444),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Log Out',
          style: getTextStyleRfDewi(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: PColors.color353534,
          ),
        ),
        content: Text(
          'Are you sure you want to log out?',
          style: getTextStyleRfDewi(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: PColors.color353534,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: getTextStyleRfDewi(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: PColors.color555555,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Log Out',
              style: getTextStyleRfDewi(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final authController = ref.read(authControllerProvider.notifier);
      await authController.signOutUser();

      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }
}
