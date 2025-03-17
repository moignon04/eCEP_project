import 'package:client/data/models/exercise.dart';
import 'package:client/domain/repositories/exercise_repository.dart';

class GetAllExercisesUseCase {
  final ExerciseRepository _repository;

  GetAllExercisesUseCase(this._repository);

  Future<List<Exercise>> execute() {
    return _repository.getAllExercises();
  }
}