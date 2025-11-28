import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hancord_test/core/errors/failures.dart';
import 'package:hancord_test/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithGoogle();
  Future<String> sendOtpToPhone(String phoneNumber);
  Future<UserModel> verifyOtp(String verificationId, String otp);
  Future<void> signOut();
  UserModel? getCurrentUser();
  Stream<firebase_auth.User?> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.googleSignIn,
  });

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw const AuthFailure('Google sign in was cancelled');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final firebase_auth.UserCredential userCredential = await firebaseAuth
          .signInWithCredential(credential);

      if (userCredential.user == null) {
        throw const AuthFailure('Failed to sign in with Google');
      }

      return UserModel.fromFirebaseUser(userCredential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthFailure(e.message ?? 'Firebase authentication error');
    } catch (e) {
      if (e is AuthFailure) rethrow;
      throw AuthFailure(e.toString());
    }
  }

  @override
  Future<String> sendOtpToPhone(String phoneNumber) async {
    try {
      final completer = Completer<String>();

      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (firebase_auth.PhoneAuthCredential credential) {
          // Auto-verification completed
          completer.complete(credential.verificationId ?? '');
        },
        verificationFailed: (firebase_auth.FirebaseAuthException e) {
          completer.completeError(
            AuthFailure(e.message ?? 'Verification failed'),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          completer.complete(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          if (!completer.isCompleted) {
            completer.complete(verificationId);
          }
        },
        timeout: const Duration(seconds: 60),
      );

      return await completer.future;
    } on AuthFailure {
      rethrow;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthFailure(e.message ?? 'Failed to send OTP');
    } catch (e) {
      if (e is AuthFailure) rethrow;
      throw AuthFailure(e.toString());
    }
  }

  @override
  Future<UserModel> verifyOtp(String verificationId, String otp) async {
    try {
      final credential = firebase_auth.PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      final firebase_auth.UserCredential userCredential = await firebaseAuth
          .signInWithCredential(credential);

      if (userCredential.user == null) {
        throw const AuthFailure('Failed to verify OTP');
      }

      return UserModel.fromFirebaseUser(userCredential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthFailure(e.message ?? 'Failed to verify OTP');
    } catch (e) {
      if (e is AuthFailure) rethrow;
      throw AuthFailure(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([firebaseAuth.signOut(), googleSignIn.signOut()]);
    } catch (e) {
      throw AuthFailure(e.toString());
    }
  }

  @override
  UserModel? getCurrentUser() {
    final user = firebaseAuth.currentUser;
    if (user == null) return null;
    return UserModel.fromFirebaseUser(user);
  }

  @override
  Stream<firebase_auth.User?> get authStateChanges =>
      firebaseAuth.authStateChanges();
}
