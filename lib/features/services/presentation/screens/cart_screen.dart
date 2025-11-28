import 'package:flutter/material.dart';
import 'package:hancord_test/core/utils/images.dart';
import 'package:hancord_test/core/utils/textStyles..dart';
import 'package:hancord_test/features/services/presentation/widgets/selected_services_section.dart';
import 'package:hancord_test/features/services/presentation/widgets/frequently_added_services_section.dart';
import 'package:hancord_test/features/services/presentation/widgets/coupon_code_section.dart';
import 'package:hancord_test/features/services/presentation/widgets/wallet_balance_info.dart';
import 'package:hancord_test/features/services/presentation/widgets/bill_details_section.dart';
import 'package:hancord_test/features/services/presentation/widgets/grand_total_card.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Sample cart data
  final List<Map<String, dynamic>> selectedServices = [
    {'name': 'Kitchen Cleaning', 'quantity': 1, 'price': 125},
    {'name': 'Fan Cleaning', 'quantity': 2, 'price': 225},
  ];

  final List<Map<String, dynamic>> frequentlyAddedServices = [
    {'name': 'Bathroom Cleaning', 'price': 500, 'image': Images.service},
    {'name': 'Bathroom Cleaning', 'price': 500, 'image': Images.service},
    {'name': 'Bathroom Cleaning', 'price': 500, 'image': Images.service},
  ];

  String couponCode = '';
  bool couponApplied = true; // Set to true to show the applied coupon
  final TextEditingController couponController = TextEditingController();

  // Bill details
  double get kitchenCleaningPrice => 499.0;
  double get fanCleaningPrice => 499.0;
  double get taxesAndFees => 50.0;
  double get couponDiscount => 150.0;
  double get total =>
      kitchenCleaningPrice + fanCleaningPrice + taxesAndFees - couponDiscount;

  @override
  void dispose() {
    couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = 16.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 43,
                height: 42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xffF7F8F8),
                ),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      size: 20,
                      color: Color(0xff2B2B2B),
                    ),
                  ),
                ),
              ),
            ),
          ),
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Cart',
            style: getTextStylNunito(
              color: const Color(0xff090F47),
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Selected Services Section
                    SelectedServicesSection(
                      selectedServices: selectedServices,
                      onRemoveService: (index) {
                        setState(() {
                          selectedServices.removeAt(index);
                        });
                      },
                      onDecrementQuantity: (index) {
                        setState(() {
                          selectedServices[index]['quantity']--;
                        });
                      },
                      onIncrementQuantity: (index) {
                        setState(() {
                          selectedServices[index]['quantity']++;
                        });
                      },
                      onAddMoreServices: () {
                        // Navigate to add more
                      },
                    ),
                    const SizedBox(height: 24),

                    // Frequently Added Services Section
                    FrequentlyAddedServicesSection(
                      frequentlyAddedServices: frequentlyAddedServices,
                      onAddService: (index) {
                        // Add service to cart
                      },
                    ),
                    const SizedBox(height: 24),

                    // Coupon Code Section
                    CouponCodeSection(
                      couponController: couponController,
                      onApplyCoupon: () {
                        // Apply coupon logic
                      },
                    ),
                    const SizedBox(height: 16),

                    // Wallet Balance Info
                    const WalletBalanceInfo(),
                    const SizedBox(height: 24),

                    // Bill Details Section
                    BillDetailsSection(
                      kitchenCleaningPrice: kitchenCleaningPrice,
                      fanCleaningPrice: fanCleaningPrice,
                      taxesAndFees: taxesAndFees,
                      couponApplied: couponApplied,
                      couponDiscount: couponDiscount,
                      total: total,
                      onRemoveCoupon: () {
                        setState(() {
                          couponApplied = false;
                          couponCode = '';
                          couponController.clear();
                        });
                      },
                    ),

                    // Space to avoid overlapping with bottom button
                    SizedBox(height: 100 + bottomPadding),
                  ],
                ),
              ),
            ),

            // Bottom Floating Grand Total Button
            Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: bottomPadding,
              ),
              child: GrandTotalCard(
                total: total,
                onBookSlot: () {
                  // Navigate to slot booking
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
