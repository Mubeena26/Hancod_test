import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hancord_test/core/utils/textStyles..dart';
import 'package:hancord_test/features/services/presentation/screens/cart_screen.dart';
import 'package:hancord_test/features/services/presentation/widgets/category_chips_widget.dart';
import 'package:hancord_test/features/services/presentation/widgets/service_card_widget.dart';
import 'package:hancord_test/features/services/presentation/widgets/cart_summary_widget.dart';
import 'package:hancord_test/features/services/presentation/providers/cart_provider.dart';
import 'package:hancord_test/features/services/presentation/providers/service_listing_provider.dart';
import 'package:hancord_test/features/services/data/dummy_services_data.dart';
import 'package:hancord_test/features/services/domain/entitities/service_model.dart';

class ServiceListingScreen extends ConsumerWidget {
  const ServiceListingScreen({super.key});

  static final List<String> categories = [
    'Deep cleaning',
    'Maid Services',
    'Car Cleaning',
    'Carpet',
  ];

  List<ServiceModel> _getFilteredServices(int selectedCategoryIndex) {
    final allServices = DummyServicesData.getServices();
    if (selectedCategoryIndex >= categories.length) return allServices;
    final selectedCategory = categories[selectedCategoryIndex];
    return allServices
        .where((service) => service.category == selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceListingState = ref.watch(serviceListingProvider);
    final selectedCategoryIndex = serviceListingState.selectedCategoryIndex;

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
                    ref
                        .read(serviceListingProvider.notifier)
                        .selectCategory(index);
                  },
                ),

                // Service List
                Expanded(child: _buildServiceList(ref, selectedCategoryIndex)),
              ],
            ),
            // Bottom Cart Summary - Floating above the screen
            Positioned(
              left: 16,
              right: 16,
              bottom: 40,
              child: _buildCartSummary(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceList(WidgetRef ref, int selectedCategoryIndex) {
    final services = _getFilteredServices(selectedCategoryIndex);

    return ListView.builder(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: 140, // Extra padding for floating cart summary
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        final cartState = ref.watch(cartProvider);
        final isInCart = cartState.items.containsKey(service.id);
        final quantity = cartState.items[service.id]?.quantity ?? 0;

        return ServiceCardWidget(
          service: service,
          isInCart: isInCart,
          quantity: quantity,
          onAddToCart: () {
            ref.read(cartProvider.notifier).addToCart(service);
          },
          onIncrementQuantity: () {
            ref.read(cartProvider.notifier).incrementQuantity(service.id);
          },
          onDecrementQuantity: () {
            ref.read(cartProvider.notifier).decrementQuantity(service.id);
          },
        );
      },
    );
  }

  Widget _buildCartSummary(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final totalItems = cartState.totalItems;
    final totalPrice = cartState.totalPrice;

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
