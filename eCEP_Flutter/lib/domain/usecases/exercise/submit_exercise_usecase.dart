import 'package:client/domain/repositories/exercise_repository.dart';

class SubmitExerciseParams {
  final int exerciseId;
  final Map<String, dynamic> answers;

  SubmitExerciseParams({
    required this.exerciseId,
    required this.answers,
  });
}

class SubmitExerciseUseCase {
  final ExerciseRepository _repository;

  SubmitExerciseUseCase(this._repository);

  Future<Map<String, dynamic>> execute(SubmitExerciseParams params) {
    return _repository.submitExercise(params.exerciseId, params.answers);
  }
}