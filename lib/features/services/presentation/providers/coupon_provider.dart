import 'package:flutter_riverpod/flutter_riverpod.dart';

class CouponState {
  final String couponCode;
  final bool couponApplied;

  CouponState({
    this.couponCode = '',
    this.couponApplied = false,
  });

  CouponState copyWith({
    String? couponCode,
    bool? couponApplied,
  }) {
    return CouponState(
      couponCode: couponCode ?? this.couponCode,
      couponApplied: couponApplied ?? this.couponApplied,
    );
  }
}

class CouponNotifier extends StateNotifier<CouponState> {
  CouponNotifier() : super(CouponState());

  void applyCoupon(String code) {
    state = state.copyWith(
      couponCode: code,
      couponApplied: code.isNotEmpty,
    );
  }

  void removeCoupon() {
    state = state.copyWith(
      couponCode: '',
      couponApplied: false,
    );
  }
}

final couponProvider =
    StateNotifierProvider<CouponNotifier, CouponState>((ref) {
  return CouponNotifier();
});

