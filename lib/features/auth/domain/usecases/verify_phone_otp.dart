import 'package:fpdart/fpdart.dart';
import 'package:hancord_test/core/errors/failures.dart';
import 'package:hancord_test/features/auth/domain/entities/user.dart';
import 'package:hancord_test/features/auth/domain/repositories/auth_repository.dart';

class VerifyPhoneOtp {
  final AuthRepository repository;

  VerifyPhoneOtp(this.repository);

  Future<Either<Failure, User>> call(String verificationId, String otp) async {
    return await repository.verifyOtp(verificationId, otp);
  }
}

