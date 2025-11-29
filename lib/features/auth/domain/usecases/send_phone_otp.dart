import 'package:fpdart/fpdart.dart';
import 'package:hancord_test/core/errors/failures.dart';
import 'package:hancord_test/features/auth/domain/repositories/auth_repository.dart';

class SendPhoneOtp {
  final AuthRepository repository;

  SendPhoneOtp(this.repository);

  Future<Either<Failure, String>> call(String phoneNumber) async {
    return await repository.sendOtpToPhone(phoneNumber);
  }
}

