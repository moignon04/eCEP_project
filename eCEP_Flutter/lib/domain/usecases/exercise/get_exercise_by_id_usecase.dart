import 'package:client/data/models/exercise.dart';
import 'package:client/domain/repositories/exercise_repository.dart';

class GetExerciseByIdParams {
  final int id;

  GetExerciseByIdParams({required this.id});
}

class GetExerciseByIdUseCase {
  final ExerciseRepository _repository;

  GetExerciseByIdUseCase(this._repository);

  Future<Exercise> execute(GetExerciseByIdParams params) {
    return _repository.getExerciseById(params.id);
  }
}