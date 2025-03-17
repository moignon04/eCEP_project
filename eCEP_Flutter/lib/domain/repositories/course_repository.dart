import 'package:client/data/models/course.dart';

abstract class CourseRepository {
  Future<List<Course>> getAllCourses();
  Future<Course> getCourseById(int id);
  Future<List<Course>> searchCourses(String query);
  Future<List<Course>> getCoursesBySubject(String subject);
}