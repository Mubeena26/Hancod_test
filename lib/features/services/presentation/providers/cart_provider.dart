import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hancord_test/core/network/supabase_client.dart';
import 'package:hancord_test/features/services/domain/entitities/service_model.dart';
import 'package:hancord_test/features/services/data/dummy_services_data.dart';

class CartItem {
  final int serviceId;
  final ServiceModel service;
  int quantity;

  CartItem({required this.serviceId, required this.service, this.quantity = 1});

  double get totalPrice => service.price * quantity;

  Map<String, dynamic> toJson() {
    return {'service_id': serviceId, 'quantity': quantity};
  }
}

class CartState {
  final Map<int, CartItem> items;
  final bool isLoading;
  final String? error;

  CartState({required this.items, this.isLoading = false, this.error});

  CartState copyWith({
    Map<int, CartItem>? items,
    bool? isLoading,
    String? error,
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  int get totalItems =>
      items.values.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      items.values.fold(0.0, (sum, item) => sum + item.totalPrice);
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState(items: {})) {
    _loadCartFromSupabase();
  }

  SupabaseClient? get _supabase {
    try {
      return SupabaseService.client;
    } catch (e) {
      return null;
    }
  }

  Future<void> _loadCartFromSupabase() async {
    try {
      state = state.copyWith(isLoading: true);

      final supabase = _supabase;
      if (supabase == null) {
        // If Supabase is not initialized, work with local cart
        state = state.copyWith(isLoading: false);
        return;
      }

      // Get current user (you may need to adjust this based on your auth setup)
      final user = supabase.auth.currentUser;
      if (user == null) {
        // If no user, work with local cart
        state = state.copyWith(isLoading: false);
        return;
      }

      // Fetch cart items from Supabase
      final response = await supabase
          .from('cart_items')
          .select('*, services(*)')
          .eq('user_id', user.id);

      final Map<int, CartItem> cartItems = {};
      final allServices = DummyServicesData.getServices();

      for (var item in response) {
        final serviceId = item['service_id'] as int;
        final quantity = item['quantity'] as int;

        // Find the service from dummy data
        final service = allServices.firstWhere(
          (s) => s.id == serviceId,
          orElse: () => ServiceModel(
            id: serviceId,
            name: 'Service',
            description: '',
            price: 0,
            image: '',
            duration: '',
            rating: 0,
            orderCount: 0,
            category: '',
          ),
        );

        cartItems[serviceId] = CartItem(
          serviceId: serviceId,
          service: service,
          quantity: quantity,
        );
      }

      state = state.copyWith(items: cartItems, isLoading: false);
    } catch (e) {
      // If Supabase table doesn't exist or other error, work with local cart
      state = state.copyWith(
        isLoading: false,
        error: null, // Don't show error for missing Supabase setup
      );
    }
  }

  Future<void> addToCart(ServiceModel service) async {
    try {
      final supabase = _supabase;
      final user = supabase?.auth.currentUser;
      final serviceId = service.id;

      // Update local state
      final currentItems = Map<int, CartItem>.from(state.items);
      if (currentItems.containsKey(serviceId)) {
        currentItems[serviceId]!.quantity++;
      } else {
        currentItems[serviceId] = CartItem(
          serviceId: serviceId,
          service: service,
          quantity: 1,
        );
      }

      state = state.copyWith(items: currentItems);

      // Sync with Supabase if user is logged in and Supabase is available
      if (supabase != null && user != null) {
        try {
          await supabase.from('cart_items').upsert({
            'user_id': user.id,
            'service_id': serviceId,
            'quantity': currentItems[serviceId]!.quantity,
          });
        } catch (e) {
          // Supabase sync failed, but local state is updated
          print('Failed to sync with Supabase: $e');
        }
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> incrementQuantity(int serviceId) async {
    try {
      final supabase = _supabase;
      final currentItems = Map<int, CartItem>.from(state.items);
      if (currentItems.containsKey(serviceId)) {
        currentItems[serviceId]!.quantity++;
        state = state.copyWith(items: currentItems);

        final user = supabase?.auth.currentUser;
        if (supabase != null && user != null) {
          try {
            await supabase.from('cart_items').upsert({
              'user_id': user.id,
              'service_id': serviceId,
              'quantity': currentItems[serviceId]!.quantity,
            });
          } catch (e) {
            print('Failed to sync with Supabase: $e');
          }
        }
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> decrementQuantity(int serviceId) async {
    try {
      final supabase = _supabase;
      final currentItems = Map<int, CartItem>.from(state.items);
      if (currentItems.containsKey(serviceId)) {
        if (currentItems[serviceId]!.quantity > 1) {
          currentItems[serviceId]!.quantity--;
        } else {
          currentItems.remove(serviceId);
        }
        state = state.copyWith(items: currentItems);

        final user = supabase?.auth.currentUser;
        if (supabase != null && user != null) {
          try {
            if (currentItems.containsKey(serviceId)) {
              await supabase.from('cart_items').upsert({
                'user_id': user.id,
                'service_id': serviceId,
                'quantity': currentItems[serviceId]!.quantity,
              });
            } else {
              await supabase
                  .from('cart_items')
                  .delete()
                  .eq('user_id', user.id)
                  .eq('service_id', serviceId);
            }
          } catch (e) {
            print('Failed to sync with Supabase: $e');
          }
        }
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> removeFromCart(int serviceId) async {
    try {
      final supabase = _supabase;
      final currentItems = Map<int, CartItem>.from(state.items);
      currentItems.remove(serviceId);
      state = state.copyWith(items: currentItems);

      final user = supabase?.auth.currentUser;
      if (supabase != null && user != null) {
        try {
          await supabase
              .from('cart_items')
              .delete()
              .eq('user_id', user.id)
              .eq('service_id', serviceId);
        } catch (e) {
          print('Failed to sync with Supabase: $e');
        }
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void clearCart() {
    state = CartState(items: {});
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});
