import 'package:hancord_test/core/errors/failures.dart';
import 'package:hancord_test/features/auth/domain/entities/user.dart';
import 'package:fpdart/fpdart.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signInWithGoogle();
  Future<Either<Failure, String>> sendOtpToPhone(String phoneNumber);
  Future<Either<Failure, User>> verifyOtp(String verificationId, String otp);
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, User?>> getCurrentUser();
  Stream<User?> get authStateChanges;
}

