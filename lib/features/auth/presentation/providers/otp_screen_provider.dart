import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OtpScreenState {
  final String phoneNumber;
  final bool canResend;
  final int resendTimer;

  OtpScreenState({
    this.phoneNumber = '',
    this.canResend = false,
    this.resendTimer = 30,
  });

  OtpScreenState copyWith({
    String? phoneNumber,
    bool? canResend,
    int? resendTimer,
  }) {
    return OtpScreenState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      canResend: canResend ?? this.canResend,
      resendTimer: resendTimer ?? this.resendTimer,
    );
  }
}

class OtpScreenNotifier extends StateNotifier<OtpScreenState> {
  Timer? _timer;
  int _currentTimer = 30;

  OtpScreenNotifier() : super(OtpScreenState());

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void setPhoneNumber(String phone) {
    state = state.copyWith(phoneNumber: phone);
  }

  void startResendTimer() {
    _timer?.cancel();
    _currentTimer = 30;
    state = state.copyWith(canResend: false, resendTimer: _currentTimer);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _currentTimer--;
      if (_currentTimer <= 0) {
        timer.cancel();
        state = state.copyWith(canResend: true, resendTimer: 0);
      } else {
        state = state.copyWith(resendTimer: _currentTimer);
      }
    });
  }

  void cancelTimer() {
    _timer?.cancel();
  }
}

final otpScreenProvider =
    StateNotifierProvider<OtpScreenNotifier, OtpScreenState>((ref) {
  final notifier = OtpScreenNotifier();
  ref.onDispose(() {
    notifier.dispose();
  });
  return notifier;
});

