import 'package:client/data/models/course.dart';
import 'package:client/domain/repositories/course_repository.dart';

class GetAllCoursesUseCase {
  final CourseRepository _repository;

  GetAllCoursesUseCase(this._repository);

  Future<List<Course>> execute() {
    return _repository.getAllCourses();
  }
}