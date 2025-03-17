import 'package:client/data/repositories/exercise_repository.dart';
import 'package:client/domain/repositories/exercise_repository.dart';
import 'package:client/domain/usecases/exercise/get_all_exercises_usecase.dart';
import 'package:client/presentation/controllers/exercises/exercises_controller.dart';
import 'package:get/get.dart';

class ExercisesBinding extends Bindings {
  @override
  void dependencies() {
    // Repository
    Get.lazyPut<ExerciseRepository>(
          () => ExerciseRepositoryImpl(),
    );

    // Use Cases
    Get.lazyPut(
          () => GetAllExercisesUseCase(Get.find<ExerciseRepository>()),
    );

    // Controller
    Get.lazyPut(
          () => ExercisesController(
        getAllExercisesUseCase: Get.find(),
      ),
    );
  }
}