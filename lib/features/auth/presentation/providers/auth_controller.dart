import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hancord_test/features/auth/domain/usecases/login_with_google.dart';
import 'package:hancord_test/features/auth/domain/usecases/send_phone_otp.dart';
import 'package:hancord_test/features/auth/domain/usecases/sign_out.dart';
import 'package:hancord_test/features/auth/domain/usecases/verify_phone_otp.dart';
import 'package:hancord_test/features/auth/presentation/providers/auth_state.dart';

class AuthController extends StateNotifier<AuthState> {
  final LoginWithGoogle loginWithGoogle;
  final SendPhoneOtp sendPhoneOtp;
  final VerifyPhoneOtp verifyPhoneOtp;
  final SignOut signOut;

  AuthController({
    required this.loginWithGoogle,
    required this.sendPhoneOtp,
    required this.verifyPhoneOtp,
    required this.signOut,
  }) : super(const AuthState());

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await loginWithGoogle();
    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (user) {
        state = state.copyWith(isLoading: false, user: user, error: null);
      },
    );
  }

  Future<void> sendOtp(String phoneNumber) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await sendPhoneOtp(phoneNumber);
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
          isOtpSent: false,
        );
      },
      (verificationId) {
        state = state.copyWith(
          isLoading: false,
          verificationId: verificationId,
          isOtpSent: true,
          error: null,
        );
      },
    );
  }

  Future<void> verifyOtp(String otp) async {
    if (state.verificationId == null) {
      state = state.copyWith(error: 'Verification ID not found');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);
    final result = await verifyPhoneOtp(state.verificationId!, otp);
    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (user) {
        state = state.copyWith(
          isLoading: false,
          user: user,
          error: null,
          verificationId: null,
          isOtpSent: false,
        );
      },
    );
  }

  Future<void> signOutUser() async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await signOut();
    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (_) {
        state = const AuthState();
      },
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
