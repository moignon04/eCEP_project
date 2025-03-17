import 'package:client/data/models/exercise.dart';

abstract class ExerciseRepository {
  Future<List<Exercise>> getAllExercises();
  Future<Exercise> getExerciseById(int id);
  Future<List<Exercise>> getExercisesByCourse(int courseId);
  Future<Map<String, dynamic>> submitExercise(int id, Map<String, dynamic> answers);
}