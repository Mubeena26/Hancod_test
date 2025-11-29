import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
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
    return {
      'service_id': serviceId,
      'quantity': quantity,
      'service': service.toJson(),
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json, ServiceModel service) {
    return CartItem(
      serviceId: json['service_id'] as int,
      service: service,
      quantity: json['quantity'] as int? ?? 1,
    );
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
  static const String _cartStorageKey = 'cart_items_local';

  CartNotifier() : super(CartState(items: {})) {
    _initializeCart();
  }

  // Get current Firebase user UID dynamically
  String? get _firebaseUserId =>
      firebase_auth.FirebaseAuth.instance.currentUser?.uid;

  SupabaseClient? get _supabase {
    try {
      return SupabaseService.client;
    } catch (e) {
      return null;
    }
  }

  Future<void> _initializeCart() async {
    state = state.copyWith(isLoading: true);

    // First try to load from local storage
    await _loadCartFromLocal();

    // Then try to sync with Supabase if available
    await _loadCartFromSupabase();

    state = state.copyWith(isLoading: false);
  }

  Future<void> _loadCartFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString(_cartStorageKey);

      if (cartJson != null) {
        final Map<String, dynamic> cartData = json.decode(cartJson);
        final Map<int, CartItem> cartItems = {};
        final allServices = DummyServicesData.getServices();

        cartData.forEach((key, value) {
          final serviceId = int.parse(key);
          final itemData = value as Map<String, dynamic>;

          // Try to get service from stored data or dummy data
          ServiceModel service;
          if (itemData['service'] != null) {
            try {
              service = ServiceModel.fromJson(
                itemData['service'] as Map<String, dynamic>,
              );
            } catch (e) {
              // Fallback to dummy data
              service = allServices.firstWhere(
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
            }
          } else {
            service = allServices.firstWhere(
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
          }

          cartItems[serviceId] = CartItem(
            serviceId: serviceId,
            service: service,
            quantity: itemData['quantity'] as int? ?? 1,
          );
        });

        state = state.copyWith(items: cartItems);
      }
    } catch (e) {
      // Error loading cart from local storage
    }
  }

  Future<void> _saveCartToLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final Map<String, dynamic> cartData = {};

      state.items.forEach((serviceId, cartItem) {
        cartData[serviceId.toString()] = cartItem.toJson();
      });

      await prefs.setString(_cartStorageKey, json.encode(cartData));
    } catch (e) {
      // Error saving cart to local storage
    }
  }

  Future<void> _loadCartFromSupabase() async {
    try {
      final supabase = _supabase;
      if (supabase == null) {
        return;
      }

      // Use Firebase UID instead of Supabase auth user
      final userId = _firebaseUserId;
      if (userId == null) {
        return;
      }

      // Fetch cart items from Supabase (no join needed, we use dummy data for services)
      final response = await supabase
          .from('cart_items')
          .select()
          .eq('user_id', userId);

      // If Supabase has no items, keep local cart (don't overwrite)
      if (response.isEmpty) {
        return;
      }

      // User is logged in and Supabase has items - use Supabase data
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

      // Update state with Supabase data
      state = state.copyWith(items: cartItems);
      await _saveCartToLocal(); // Sync Supabase data to local storage
    } catch (e) {
      // If Supabase table doesn't exist or other error, continue with local cart
      // Don't clear local cart on error - keep what we have
    }
  }

  Future<void> addToCart(ServiceModel service) async {
    try {
      final supabase = _supabase;
      final userId = _firebaseUserId;
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

      // Save to local storage
      await _saveCartToLocal();

      // Sync with Supabase if user is logged in and Supabase is available
      if (supabase != null && userId != null) {
        try {
          await supabase.from('cart_items').upsert({
            'user_id': userId,
            'service_id': serviceId,
            'quantity': currentItems[serviceId]!.quantity,
          });
        } catch (e) {
          // Supabase sync failed, but local state is updated
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

        // Save to local storage
        await _saveCartToLocal();

        final userId = _firebaseUserId;
        if (supabase != null && userId != null) {
          try {
            await supabase.from('cart_items').upsert({
              'user_id': userId,
              'service_id': serviceId,
              'quantity': currentItems[serviceId]!.quantity,
            });
          } catch (e) {
            // Failed to sync with Supabase
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

        // Save to local storage
        await _saveCartToLocal();

        final userId = _firebaseUserId;
        if (supabase != null && userId != null) {
          try {
            if (currentItems.containsKey(serviceId)) {
              await supabase.from('cart_items').upsert({
                'user_id': userId,
                'service_id': serviceId,
                'quantity': currentItems[serviceId]!.quantity,
              });
            } else {
              await supabase
                  .from('cart_items')
                  .delete()
                  .eq('user_id', userId)
                  .eq('service_id', serviceId);
            }
          } catch (e) {
            // Failed to sync with Supabase
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

      // Save to local storage
      await _saveCartToLocal();

      final userId = _firebaseUserId;
      if (supabase != null && userId != null) {
        try {
          await supabase
              .from('cart_items')
              .delete()
              .eq('user_id', userId)
              .eq('service_id', serviceId);
        } catch (e) {
          // Failed to sync with Supabase
        }
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> clearCart() async {
    state = CartState(items: {});
    await _saveCartToLocal();
  }
}

// Provider to watch Firebase auth state changes
final _firebaseAuthStateProvider = StreamProvider<firebase_auth.User?>((ref) {
  return firebase_auth.FirebaseAuth.instance.authStateChanges();
});

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  final notifier = CartNotifier();

  // Listen to Firebase auth state changes and reload cart when user logs in/out
  ref.listen(_firebaseAuthStateProvider, (previous, next) {
    final previousUid = previous?.valueOrNull?.uid;
    final nextUid = next.valueOrNull?.uid;
    if (previousUid != nextUid) {
      // User logged in or out, reload cart from Supabase
      notifier._initializeCart();
    }
  });

  return notifier;
});
