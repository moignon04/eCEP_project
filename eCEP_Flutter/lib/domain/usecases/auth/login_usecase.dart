import 'package:client/domain/entities/user.dart';
import 'package:client/domain/repositories/auth_repository.dart';

class LoginParams {
  final String email;
  final String password;

  LoginParams({
    required this.email,
    required this.password,
  });
}

class LoginUseCase {
  final AuthenticationRepository _repository;

  LoginUseCase(this._repository);

  Future<User> execute(LoginParams params) {
    return _repository.login(params.email, params.password);
  }
}