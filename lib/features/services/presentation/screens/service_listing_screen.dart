import 'package:flutter/material.dart';
import 'package:hancord_test/core/utils/textStyles..dart';
import 'package:hancord_test/features/services/presentation/screens/cart_screen.dart';
import 'package:hancord_test/features/services/presentation/widgets/category_chips_widget.dart';
import 'package:hancord_test/features/services/presentation/widgets/service_card_widget.dart';
import 'package:hancord_test/features/services/presentation/widgets/cart_summary_widget.dart';

class ServiceListingScreen extends StatefulWidget {
  const ServiceListingScreen({super.key});

  @override
  State<ServiceListingScreen> createState() => _ServiceListingScreenState();
}

class _ServiceListingScreenState extends State<ServiceListingScreen> {
  int selectedCategoryIndex = 1; // Maid Services is selected
  Map<int, int> cartItems = {1: 1, 2: 1}; // Items 1 and 2 are in cart

  final List<String> categories = [
    'Deep cleaning',
    'Maid Services',
    'Car Cleaning',
    'Carpet',
  ];

  @override
  Widget build(BuildContext context) {
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
          flexibleSpace: Container(decoration: const BoxDecoration()),
          centerTitle: true,
          title: Transform.translate(
            offset: Offset(-60, 0),
            child: Text(
              'Cleaning Services',
              style: getTextStylNunito(
                color: Color(0xff090F47),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Category Chips
                CategoryChipsWidget(
                  categories: categories,
                  selectedCategoryIndex: selectedCategoryIndex,
                  onCategorySelected: (index) {
                    setState(() {
                      selectedCategoryIndex = index;
                    });
                  },
                ),

                // Service List
                Expanded(child: _buildServiceList()),
              ],
            ),
            // Bottom Cart Summary - Floating above the screen
            Positioned(
              left: 16,
              right: 16,
              bottom: 40,
              child: _buildCartSummary(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceList() {
    return ListView.builder(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: 140, // Extra padding for floating cart summary
      ),
      itemCount: 6, // 4 service cards visible
      itemBuilder: (context, index) {
        final itemId = index;
        final isInCart = cartItems.containsKey(itemId);
        final quantity = cartItems[itemId] ?? 0;

        return ServiceCardWidget(
          itemId: itemId,
          isInCart: isInCart,
          quantity: quantity,
          onAddToCart: () {
            setState(() {
              cartItems[itemId] = 1;
            });
          },
          onIncrementQuantity: () {
            setState(() {
              cartItems[itemId] = quantity + 1;
            });
          },
          onDecrementQuantity: () {
            setState(() {
              if (quantity > 1) {
                cartItems[itemId] = quantity - 1;
              } else {
                cartItems.remove(itemId);
              }
            });
          },
        );
      },
    );
  }

  Widget _buildCartSummary() {
    final totalItems = cartItems.values.fold(0, (sum, qty) => sum + qty);
    final totalPrice = totalItems > 0
        ? (totalItems == 2 ? 3355.0 : totalItems * 499.0)
        : 0.0;

    return CartSummaryWidget(
      totalItems: totalItems,
      totalPrice: totalPrice,
      onViewCart: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CartScreen()),
        );
      },
    );
  }
}
