// lib/presentation/controllers/home/home_binding.dart
import 'package:client/app/services/local_storage.dart';
import 'package:client/data/repositories/badge_repository.dart';
import 'package:client/data/repositories/course_repository.dart';
import 'package:client/domain/repositories/badge_repository.dart';
import 'package:client/domain/repositories/course_repository.dart';
import 'package:client/domain/usecases/badge/get_badges_by_student_usecase.dart';
import 'package:client/domain/usecases/course/get_all_courses_usecase.dart';
import 'package:client/presentation/controllers/home/home_page_controller.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Repositories
    Get.lazyPut<CourseRepository>(
          () => CourseRepositoryImpl(),
    );
    Get.lazyPut<BadgeRepository>(
          () => BadgeRepositoryImpl(),
    );

    // Use Cases
    Get.lazyPut(
          () => GetAllCoursesUseCase(Get.find<CourseRepository>()),
    );
    Get.lazyPut(
          () => GetBadgesByStudentUseCase(Get.find<BadgeRepository>()),
    );

    // Controller
    Get.lazyPut(
          () => HomeController(
        getCoursesUseCase: Get.find(),
        getBadgesUseCase: Get.find(),
        storageService: Get.find<LocalStorageService>(),
      ),
    );
  }
}