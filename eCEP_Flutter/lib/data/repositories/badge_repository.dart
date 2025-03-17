import 'package:client/data/models/badge.dart';
import 'package:client/data/providers/network/api_provider.dart';
import 'package:client/data/providers/network/apis/badge_api.dart';
import 'package:client/domain/repositories/badge_repository.dart';

class BadgeRepositoryImpl implements BadgeRepository {
  @override
  Future<List<ABadge>> getAllBadges() async {
    try {
      final response = await BadgeAPI.getAll().request();

      final List<dynamic> badgesData = response['datas'];
      return badgesData.map((data) => ABadge.fromJson(data)).toList();
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      throw Exception('Erreur lors de la récupération des badges: $e');
    }
  }

  @override
  Future<List<ABadge>> getBadgesByStudent(int studentId) async {
    try {
      final response = await BadgeAPI.getByStudent(studentId).request();

      final List<dynamic> badgesData = response['datas'];
      return badgesData.map((data) => ABadge.fromJson(data)).toList();
    } on AppException catch (e) {
      rethrow;
    } catch (e) {
      throw Exception('Erreur lors de la récupération des badges de l\'étudiant: $e');
    }
  }
}