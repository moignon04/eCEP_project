import 'package:client/data/models/badge.dart';

abstract class BadgeRepository {
  Future<List<ABadge>> getAllBadges();
  Future<List<ABadge>> getBadgesByStudent(int studentId);
}