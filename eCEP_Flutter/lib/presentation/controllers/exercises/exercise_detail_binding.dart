import 'package:client/data/repositories/exercise_repository.dart';
import 'package:client/domain/repositories/exercise_repository.dart';
import 'package:client/domain/usecases/exercise/get_exercise_by_id_usecase.dart';
import 'package:client/domain/usecases/exercise/submit_exercise_usecase.dart';
import 'package:client/presentation/controllers/exercises/exercises_details_controller.dart';
import 'package:get/get.dart';

class ExerciseDetailBinding extends Bindings {
  @override
  void dependencies() {
    // Repository
    Get.lazyPut<ExerciseRepository>(
          () => ExerciseRepositoryImpl(),
    );

    // Use Cases
    Get.lazyPut(
          () => GetExerciseByIdUseCase(Get.find<ExerciseRepository>()),
    );
    Get.lazyPut(
          () => SubmitExerciseUseCase(Get.find<ExerciseRepository>()),
    );

    // Controller
    Get.lazyPut(
          () => ExerciseDetailController(
        getExerciseByIdUseCase: Get.find(),
        submitExerciseUseCase: Get.find(),
      ),
    );
  }
}