import 'package:client/data/models/course.dart';
import 'package:client/domain/repositories/course_repository.dart';

class SearchCoursesParams {
  final String query;

  SearchCoursesParams({required this.query});
}

class SearchCoursesUseCase {
  final CourseRepository _repository;

  SearchCoursesUseCase(this._repository);

  Future<List<Course>> execute(SearchCoursesParams params) {
    return _repository.searchCourses(params.query);
  }
}