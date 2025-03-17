import 'package:client/data/models/badge.dart';
import 'package:client/domain/repositories/badge_repository.dart';

class GetBadgesByStudentParams {
  final int studentId;

  GetBadgesByStudentParams({required this.studentId});
}

class GetBadgesByStudentUseCase {
  final BadgeRepository _repository;

  GetBadgesByStudentUseCase(this._repository);

  Future<List<ABadge>> execute(GetBadgesByStudentParams params) {
    return _repository.getBadgesByStudent(params.studentId);
  }
}