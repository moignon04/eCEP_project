import 'dart:convert';
import 'package:client/domain/entities/user.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService extends GetxService {
  SharedPreferences? _sharedPreferences;
  final _box = GetStorage();
  Future<LocalStorageService> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return this;
  }
  // Clés de stockage
  static const String _tokenKey = 'token';
  static const String _userKey = 'user';
  static const String _levelKey = 'level';
  static const String _pointsKey = 'points';
  static const String _streakDaysKey = 'streak_days';
  static const String _completedCoursesKey = 'completed_courses';
  static const String _completedExercisesKey = 'completed_exercises';
  static const String _averageScoreKey = 'average_score';

  // Getter pour le token
  String? get token => _box.read<String>(_tokenKey);

  // Setter pour le token
  set token(String? value) => _box.write(_tokenKey, value);
  // Getter pour l'utilisateur
  User? get user {
    final userData = _box.read<String>(_userKey);
    if (userData != null) {
      try {
        return User.fromJson(json.decode(userData));
      } catch (e) {
        print('Erreur lors de la conversion des données utilisateur: $e');
        return null;
      }
    }
    return null;
  }
  // Gestion de l'onboarding
  bool get onboardingCompleted =>
      _sharedPreferences?.getBool('onboardingCompleted') ?? false;

  set onboardingCompleted(bool value) {
    _sharedPreferences?.setBool('onboardingCompleted', value);
  }
  // Setter pour l'utilisateur
  set user(User? value) {
    if (value != null) {
      _box.write(_userKey, json.encode(value.toJson()));
    } else {
      _box.remove(_userKey);
    }
  }

  // Getters et setters pour les autres informations
  int? get level => _box.read<int>(_levelKey);
  set level(int? value) => value != null ? _box.write(_levelKey, value) : _box.remove(_levelKey);

  int? get points => _box.read<int>(_pointsKey);
  set points(int? value) => value != null ? _box.write(_pointsKey, value) : _box.remove(_pointsKey);

  int? get streakDays => _box.read<int>(_streakDaysKey);
  set streakDays(int? value) => value != null ? _box.write(_streakDaysKey, value) : _box.remove(_streakDaysKey);

  int? get completedCourses => _box.read<int>(_completedCoursesKey);
  set completedCourses(int? value) => value != null ? _box.write(_completedCoursesKey, value) : _box.remove(_completedCoursesKey);

  int? get completedExercises => _box.read<int>(_completedExercisesKey);
  set completedExercises(int? value) => value != null ? _box.write(_completedExercisesKey, value) : _box.remove(_completedExercisesKey);

  double? get averageScore => _box.read<double>(_averageScoreKey);
  set averageScore(double? value) => value != null ? _box.write(_averageScoreKey, value) : _box.remove(_averageScoreKey);

  // Effacer les données de l'utilisateur lors de la déconnexion
  void clearUserData() {
    _box.remove(_tokenKey);
    _box.remove(_userKey);
    // Optionnel: conserver les statistiques même après déconnexion
    // _box.remove(_levelKey);
    // _box.remove(_pointsKey);
    // _box.remove(_streakDaysKey);
    // _box.remove(_completedCoursesKey);
    // _box.remove(_completedExercisesKey);
    // _box.remove(_averageScoreKey);
  }

  // Vérifier si l'utilisateur est authentifié
  bool get isAuthenticated => token != null && user != null;
}
