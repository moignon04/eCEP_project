import 'package:client/app/services/local_storage.dart';
import 'package:client/data/repositories/auth_repository.dart';
import 'package:client/domain/repositories/auth_repository.dart';
import 'package:client/domain/usecases/auth/login_usecase.dart';
import 'package:client/domain/usecases/auth/logout_usecase.dart';
import 'package:client/domain/usecases/auth/signup_use_case.dart';
import 'package:client/presentation/controllers/auth/auth_controller.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Repositories
    Get.lazyPut<AuthenticationRepository>(
          () => AuthenticationRepositoryImpl(),
    );

    // Use Cases
    Get.lazyPut(
          () => LoginUseCase(Get.find<AuthenticationRepository>()),
    );
    Get.lazyPut(
          () => SignUpUseCase(Get.find<AuthenticationRepository>()),
    );
    Get.lazyPut(
          () => LogoutUseCase(Get.find<AuthenticationRepository>()),
    );

    // Controller
    Get.lazyPut(
          () => AuthController(
        loginUseCase: Get.find(),
        signUpUseCase: Get.find(),
        logoutUseCase: Get.find(),
        storageService: Get.find<LocalStorageService>(),
      ),
    );
  }
}