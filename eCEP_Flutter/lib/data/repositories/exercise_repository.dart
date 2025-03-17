import 'package:client/data/models/exercise.dart';
import 'package:client/data/providers/network/api_provider.dart';
import 'package:client/data/providers/network/apis/exercise_api.dart';
import 'package:client/domain/repositories/exercise_repository.dart';

class ExerciseRepositoryImpl implements ExerciseRepository {
  @override
  Future<List<Exercise>> getAllExercises() async {
    try {
      final response = await ExerciseAPI.getAll().request();

      final List<dynamic> exercisesData = response['datas'];
      return exercisesData.map((data) => Exercise.fromJson(data)).toList();
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      throw Exception('Erreur lors de la récupération des exercices: $e');
    }
  }

  @override
  Future<Exercise> getExerciseById(int id) async {
    try {
      final response = await ExerciseAPI.getById(id).request();

      return Exercise.fromJson(response['datas']);
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'exercice: $e');
    }
  }

  @override
  Future<List<Exercise>> getExercisesByCourse(int courseId) async {
    try {
      final response = await ExerciseAPI.getByCourse(courseId).request();

      final List<dynamic> exercisesData = response['datas'];
      return exercisesData.map((data) => Exercise.fromJson(data)).toList();
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      throw Exception('Erreur lors de la récupération des exercices du cours: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> submitExercise(int id, Map<String, dynamic> answers) async {
    try {
      final response = await ExerciseAPI.submit(id, answers).request();

      return response['datas'];
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      throw Exception('Erreur lors de la soumission de l\'exercice: $e');
    }
  }
}