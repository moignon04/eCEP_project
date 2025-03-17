import 'package:client/data/providers/network/api_provider.dart';
import 'package:client/data/providers/network/apis/auth_api.dart';
import 'package:client/domain/entities/user.dart';
import 'package:client/domain/repositories/auth_repository.dart';
import 'package:client/app/services/local_storage.dart';
import 'package:get/get.dart';

class AuthenticationRepositoryImpl extends AuthenticationRepository {
  final store = Get.find<LocalStorageService>();

  @override
  Future<User> signUp(String email, String password, String firstName, String lastName, String role) async {
    try {
      final response = await AuthAPI.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        role: role,
      ).request();

      final user = User.fromJson(response['datas']['user']);

      // Stockage du token
      store.token = response['datas']['token'];
      // Stockage de l'utilisateur
      store.user = user;

      return user;
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      throw Exception('Erreur lors de l\'inscription: $e');
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await AuthAPI.login(
        email: email,
        password: password,
      ).request();

      final user = User.fromJson(response['datas']['user']);

      // Stockage du token
      store.token = response['datas']['token'];
      // Stockage de l'utilisateur
      store.user = user;

      return user;
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      throw Exception('Erreur lors de la connexion: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await AuthAPI.logout().request();
      // Suppression du token et des informations utilisateur

    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      throw Exception('Erreur lors de la déconnexion: $e');
    }
  }
}