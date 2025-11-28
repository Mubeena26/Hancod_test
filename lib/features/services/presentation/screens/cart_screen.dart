import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hancord_test/core/utils/images.dart';
import 'package:hancord_test/core/utils/textStyles..dart';
import 'package:hancord_test/features/services/presentation/widgets/selected_services_section.dart';
import 'package:hancord_test/features/services/presentation/widgets/frequently_added_services_section.dart';
import 'package:hancord_test/features/services/presentation/widgets/coupon_code_section.dart';
import 'package:hancord_test/features/services/presentation/widgets/wallet_balance_info.dart';
import 'package:hancord_test/features/services/presentation/widgets/bill_details_section.dart';
import 'package:hancord_test/features/services/presentation/widgets/grand_total_card.dart';
import 'package:hancord_test/features/services/presentation/providers/cart_provider.dart';
import 'package:hancord_test/features/services/presentation/providers/coupon_provider.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final List<Map<String, dynamic>> frequentlyAddedServices = [
    {'name': 'Bathroom Cleaning', 'price': 500, 'image': Images.service},
    {'name': 'Bathroom Cleaning', 'price': 500, 'image': Images.service},
    {'name': 'Bathroom Cleaning', 'price': 500, 'image': Images.service},
  ];

  final TextEditingController couponController = TextEditingController();

  // Bill details
  double get taxesAndFees => 50.0;

  @override
  void dispose() {
    couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final couponState = ref.watch(couponProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final double bottomPadding = 16.0;

    // Convert cart items to the format expected by SelectedServicesSection
    final List<Map<String, dynamic>> selectedServices = cartState.items.values
        .map(
          (cartItem) => {
            'id': cartItem.serviceId,
            'name': cartItem.service.name,
            'quantity': cartItem.quantity,
            'price': cartItem.service.price,
            'totalPrice': cartItem.totalPrice,
          },
        )
        .toList();

    // Calculate bill details from cart items
    final double subtotal = cartState.totalPrice;
    final double couponDiscount = couponState.couponApplied ? 150.0 : 0.0;
    final double total = subtotal + taxesAndFees - couponDiscount;

    // Show loading or empty state
    if (cartState.isLoading) {
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
            title: Transform.translate(
              offset: Offset(40, 0),
              child: Text(
                'Cart',
                style: getTextStylNunito(
                  color: const Color(0xff090F47),
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Show empty cart state
    if (selectedServices.isEmpty) {
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Your cart is empty',
                style: getTextStylNunito(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      );
    }

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
                        final serviceId = selectedServices[index]['id'] as int;
                        cartNotifier.removeFromCart(serviceId);
                      },
                      onDecrementQuantity: (index) {
                        final serviceId = selectedServices[index]['id'] as int;
                        cartNotifier.decrementQuantity(serviceId);
                      },
                      onIncrementQuantity: (index) {
                        final serviceId = selectedServices[index]['id'] as int;
                        cartNotifier.incrementQuantity(serviceId);
                      },
                      onAddMoreServices: () {
                        Navigator.pop(context);
                        // Navigate to service listing
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
                        final code = couponController.text.trim();
                        ref.read(couponProvider.notifier).applyCoupon(code);
                      },
                    ),
                    const SizedBox(height: 16),

                    // Wallet Balance Info
                    const WalletBalanceInfo(),
                    const SizedBox(height: 24),

                    // Bill Details Section
                    BillDetailsSection(
                      subtotal: subtotal,
                      cartItems: selectedServices,
                      taxesAndFees: taxesAndFees,
                      couponApplied: couponState.couponApplied,
                      couponDiscount: couponDiscount,
                      total: total,
                      onRemoveCoupon: () {
                        ref.read(couponProvider.notifier).removeCoupon();
                        couponController.clear();
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
