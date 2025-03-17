import 'package:client/data/models/course.dart';
import 'package:client/data/providers/network/api_provider.dart';
import 'package:client/data/providers/network/apis/course_api.dart';
import 'package:client/domain/repositories/course_repository.dart';

class CourseRepositoryImpl implements CourseRepository {
  @override
  Future<List<Course>> getAllCourses() async {
    try {
      final response = await CourseAPI.getAll().request();

      final List<dynamic> coursesData = response['datas'];
      return coursesData.map((data) => Course.fromJson(data)).toList();
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      throw Exception('Erreur lors de la récupération des cours: $e');
    }
  }

  @override
  Future<Course> getCourseById(int id) async {
    try {
      final response = await CourseAPI.getById(id).request();

      return Course.fromJson(response['datas']);
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      throw Exception('Erreur lors de la récupération du cours: $e');
    }
  }

  @override
  Future<List<Course>> searchCourses(String query) async {
    try {
      final response = await CourseAPI.search(query).request();

      final List<dynamic> coursesData = response['datas'];
      return coursesData.map((data) => Course.fromJson(data)).toList();
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      throw Exception('Erreur lors de la recherche de cours: $e');
    }
  }

  @override
  Future<List<Course>> getCoursesBySubject(String subject) async {
    try {
      final response = await CourseAPI.getBySubject(subject).request();

      final List<dynamic> coursesData = response['datas'];
      return coursesData.map((data) => Course.fromJson(data)).toList();
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      throw Exception('Erreur lors de la récupération des cours par matière: $e');
    }
  }
}