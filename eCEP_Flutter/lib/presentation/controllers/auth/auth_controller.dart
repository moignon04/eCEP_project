import 'package:client/app/services/local_storage.dart';
import 'package:client/data/providers/network/api_provider.dart';
import 'package:client/domain/entities/user.dart';
import 'package:client/domain/usecases/auth/login_usecase.dart';
import 'package:client/domain/usecases/auth/logout_usecase.dart';
import 'package:client/domain/usecases/auth/signup_use_case.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final LoginUseCase _loginUseCase;
  final SignUpUseCase _signUpUseCase;
  final LogoutUseCase _logoutUseCase;
  final LocalStorageService _storageService;

  AuthController({
    required LoginUseCase loginUseCase,
    required SignUpUseCase signUpUseCase,
    required LogoutUseCase logoutUseCase,
    required LocalStorageService storageService,
  })  : _loginUseCase = loginUseCase,
        _signUpUseCase = signUpUseCase,
        _logoutUseCase = logoutUseCase,
        _storageService = storageService;

  final Rx<User?> user = Rx<User?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    user.value = _storageService.user;
  }

  // Connexion avec email et mot de passe
  // Dans AuthController
  Future<bool> login(String email, String password) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final params = LoginParams(
        email: email,
        password: password,
      );

      final loggedUser = await _loginUseCase.execute(params);
      user.value = loggedUser;
      isLoading.value = false;

      // Redirection basée sur le rôle
      _redirectByRole(loggedUser.role);

      return true;
    } on AppException catch (e) {
      errorMessage.value = e.message ?? 'Une erreur est survenue';
      isLoading.value = false;
      return false;
    } catch (e) {
      errorMessage.value = 'Une erreur inattendue est survenue';
      isLoading.value = false;
      return false;
    }
  }

// Méthode privée pour gérer la redirection
  void _redirectByRole(String role) {
    switch (role) {
      case 'student':
        Get.offAllNamed('/student/home');
        break;
      case 'teacher':
        Get.offAllNamed('/teacher/dashboard');
        break;
      case 'parent':
        Get.offAllNamed('/parent/dashboard');
        break;
      case 'admin':
        Get.offAllNamed('/admin/dashboard');
        break;
      default:
        Get.offAllNamed('/login');
    }
  }

  // Inscription
  Future<bool> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final params = SignUpParams(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        role: role,
      );

      final newUser = await _signUpUseCase.execute(params);
      user.value = newUser;
      isLoading.value = false;
      return true;
    } on AppException catch (e) {
      errorMessage.value = e.message ?? 'Une erreur est survenue';
      isLoading.value = false;
      return false;
    } catch (e) {
      errorMessage.value = 'Une erreur inattendue est survenue';
      isLoading.value = false;
      return false;
    }
  }

  // Déconnexion
  Future<void> logout() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      await _logoutUseCase.execute();
      user.value = null;
      isLoading.value = false;
      Get.offAllNamed('/login');
    } on AppException catch (e) {
      errorMessage.value = e.message ?? 'Une erreur est survenue';
      isLoading.value = false;
    } catch (e) {
      errorMessage.value = 'Une erreur inattendue est survenue';
      isLoading.value = false;
    }
  }
}