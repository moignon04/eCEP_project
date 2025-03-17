import 'package:client/data/models/course.dart';
import 'package:client/domain/repositories/course_repository.dart';

class GetCourseByIdParams {
  final int id;

  GetCourseByIdParams({required this.id});
}

class GetCourseByIdUseCase {
  final CourseRepository _repository;

  GetCourseByIdUseCase(this._repository);

  Future<Course> execute(GetCourseByIdParams params) {
    return _repository.getCourseById(params.id);
  }
}