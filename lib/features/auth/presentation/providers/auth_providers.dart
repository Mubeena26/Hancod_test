import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hancord_test/features/auth/data/auth_repository_impl.dart';
import 'package:hancord_test/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:hancord_test/features/auth/domain/repositories/auth_repository.dart';
import 'package:hancord_test/features/auth/domain/usecases/get_current_user.dart';
import 'package:hancord_test/features/auth/domain/usecases/login_with_google.dart';
import 'package:hancord_test/features/auth/domain/usecases/send_phone_otp.dart';
import 'package:hancord_test/features/auth/domain/usecases/sign_out.dart';
import 'package:hancord_test/features/auth/domain/usecases/verify_phone_otp.dart';
import 'package:hancord_test/features/auth/presentation/providers/auth_controller.dart';
import 'package:hancord_test/features/auth/presentation/providers/auth_state.dart';

// Firebase and Google Sign-In instances
final _firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);
final _googleSignInProvider = Provider<GoogleSignIn>((ref) => GoogleSignIn());

// Data source provider
final _authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(
    firebaseAuth: ref.watch(_firebaseAuthProvider),
    googleSignIn: ref.watch(_googleSignInProvider),
  );
});

// Repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(_authRemoteDataSourceProvider));
});

// Use cases providers
final loginWithGoogleProvider = Provider<LoginWithGoogle>((ref) {
  return LoginWithGoogle(ref.watch(authRepositoryProvider));
});

final sendPhoneOtpProvider = Provider<SendPhoneOtp>((ref) {
  return SendPhoneOtp(ref.watch(authRepositoryProvider));
});

final verifyPhoneOtpProvider = Provider<VerifyPhoneOtp>((ref) {
  return VerifyPhoneOtp(ref.watch(authRepositoryProvider));
});

final signOutProvider = Provider<SignOut>((ref) {
  return SignOut(ref.watch(authRepositoryProvider));
});

final getCurrentUserProvider = Provider<GetCurrentUser>((ref) {
  return GetCurrentUser(ref.watch(authRepositoryProvider));
});

// Auth state provider
final authStateProvider = StreamProvider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges;
});

// Auth controller provider
final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    return AuthController(
      loginWithGoogle: ref.watch(loginWithGoogleProvider),
      sendPhoneOtp: ref.watch(sendPhoneOtpProvider),
      verifyPhoneOtp: ref.watch(verifyPhoneOtpProvider),
      signOut: ref.watch(signOutProvider),
    );
  },
);
