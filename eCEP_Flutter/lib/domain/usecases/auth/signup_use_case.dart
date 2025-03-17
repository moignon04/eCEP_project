import 'package:client/domain/entities/user.dart';
import 'package:client/domain/repositories/auth_repository.dart';

class SignUpParams {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String role;

  SignUpParams({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.role,
  });
}

class SignUpUseCase {
  final AuthenticationRepository _repository;

  SignUpUseCase(this._repository);

  Future<User> execute(SignUpParams params) {
    return _repository.signUp(
      params.email,
      params.password,
      params.firstName,
      params.lastName,
      params.role,
    );
  }
}