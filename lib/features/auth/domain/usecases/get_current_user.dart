import 'package:fpdart/fpdart.dart';
import 'package:hancord_test/core/errors/failures.dart';
import 'package:hancord_test/features/auth/domain/entities/user.dart';
import 'package:hancord_test/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUser {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  Future<Either<Failure, User?>> call() async {
    return await repository.getCurrentUser();
  }
}

