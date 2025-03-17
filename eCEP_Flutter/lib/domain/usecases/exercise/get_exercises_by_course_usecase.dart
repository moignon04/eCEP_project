import 'package:client/data/models/exercise.dart';
import 'package:client/domain/repositories/exercise_repository.dart';

class GetExercisesByCourseParams {
  final int courseId;

  GetExercisesByCourseParams({required this.courseId});
}

class GetExercisesByCourseUseCase {
  final ExerciseRepository _repository;

  GetExercisesByCourseUseCase(this._repository);

  Future<List<Exercise>> execute(GetExercisesByCourseParams params) {
    return _repository.getExercisesByCourse(params.courseId);
  }
}