import 'package:client/domain/entities/user.dart';

abstract class AuthenticationRepository {
  Future<User> signUp(String email, String password, String firstName, String lastName, String role);
  Future<User> login(String email, String password);
  Future<void> logout();
}