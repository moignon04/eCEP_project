import 'package:client/data/repositories/course_repository.dart';
import 'package:client/domain/repositories/course_repository.dart';
import 'package:client/domain/usecases/course/get_course_by_id_usecase.dart';
import 'package:client/presentation/controllers/courses/course_details_controller.dart';
import 'package:get/get.dart';

class CourseDetailBinding extends Bindings {
  @override
  void dependencies() {
    // Repository
    Get.lazyPut<CourseRepository>(
          () => CourseRepositoryImpl(),
    );

    // Use Cases
    Get.lazyPut(
          () => GetCourseByIdUseCase(Get.find<CourseRepository>()),
    );

    // Controller
    Get.lazyPut(
          () => CourseDetailController(
        getCourseByIdUseCase: Get.find(),
      ),
    );
  }
}