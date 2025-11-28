import 'package:equatable/equatable.dart';
import 'package:hancord_test/features/auth/domain/entities/user.dart';

class AuthState extends Equatable {
  final bool isLoading;
  final User? user;
  final String? error;
  final String? verificationId;
  final bool isOtpSent;

  const AuthState({
    this.isLoading = false,
    this.user,
    this.error,
    this.verificationId,
    this.isOtpSent = false,
  });

  AuthState copyWith({
    bool? isLoading,
    User? user,
    String? error,
    String? verificationId,
    bool? isOtpSent,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
      verificationId: verificationId ?? this.verificationId,
      isOtpSent: isOtpSent ?? this.isOtpSent,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    user,
    error,
    verificationId,
    isOtpSent,
  ];
}
