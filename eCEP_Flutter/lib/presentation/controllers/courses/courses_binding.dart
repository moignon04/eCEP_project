import 'package:client/data/repositories/course_repository.dart';
import 'package:client/domain/repositories/course_repository.dart';
import 'package:client/domain/usecases/course/get_all_courses_usecase.dart';
import 'package:client/domain/usecases/course/search_courses_usecase.dart';
import 'package:client/presentation/controllers/courses/courses_controller.dart';
import 'package:get/get.dart';

class CoursesBinding extends Bindings {
  @override
  void dependencies() {
    // Repository
    print("Initializing CourseRepository...");
    Get.lazyPut<CourseRepository>(
          () => CourseRepositoryImpl(),
    );

    print("Initializing GetAllCoursesUseCase...");
    Get.lazyPut<GetAllCoursesUseCase>(
          () => GetAllCoursesUseCase(Get.find<CourseRepository>()),
    );

    print("Initializing SearchCoursesUseCase...");
    try {
      Get.lazyPut<SearchCoursesUseCase>(
            () => SearchCoursesUseCase(Get.find<CourseRepository>()),
      );
      print("SearchCoursesUseCase initialized successfully!");
    } catch (e) {
      print("Error initializing SearchCoursesUseCase: $e");
    }

    print("Initializing CoursesController...");
    Get.lazyPut<CoursesController>(
          () => CoursesController(
        getAllCoursesUseCase: Get.find<GetAllCoursesUseCase>(),
        searchCoursesUseCase: Get.find<SearchCoursesUseCase>(),
      ),
    );
    print("CoursesController initialized successfully!");
  }
}