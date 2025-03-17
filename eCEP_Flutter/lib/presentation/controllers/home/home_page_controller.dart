// lib/presentation/controllers/home/home_page_controller.dart
import 'package:client/app/services/local_storage.dart';
import 'package:client/data/models/badge.dart';
import 'package:client/data/models/course.dart';
import 'package:client/data/models/mock_data.dart'; // Importation des données simulées
import 'package:client/data/providers/network/api_provider.dart';
import 'package:client/domain/entities/user.dart';
import 'package:client/domain/usecases/badge/get_badges_by_student_usecase.dart';
import 'package:client/domain/usecases/course/get_all_courses_usecase.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final GetAllCoursesUseCase _getCoursesUseCase;
  final GetBadgesByStudentUseCase _getBadgesUseCase;
  final LocalStorageService _storageService;

  HomeController({
    required GetAllCoursesUseCase getCoursesUseCase,
    required GetBadgesByStudentUseCase getBadgesUseCase,
    required LocalStorageService storageService,
  })  : _getCoursesUseCase = getCoursesUseCase,
        _getBadgesUseCase = getBadgesUseCase,
        _storageService = storageService;

  final RxMap<String, dynamic> profile = <String, dynamic>{}.obs;
  final RxList<Course> courses = <Course>[].obs;
  final RxList<ABadge> badges = <ABadge>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  // Chargement des données - version temporaire avec données simulées
  Future<void> loadData() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Chargement du profil
      loadProfile();

      // Données simulées pendant le développement
      // À remplacer par les appels API réels quand ils seront prêts
      await Future.delayed(Duration(milliseconds: 500)); // Simuler un délai de chargement

      // Récupérer les cours depuis MockData
      List<Course> mockCourses = MockData.courses.map((data) => Course.fromJson(data)).toList();
      courses.value = mockCourses;

      // Récupérer les badges depuis MockData
      List<ABadge> mockBadges = MockData.badges.map((data) => ABadge.fromJson(data)).toList();
      badges.value = mockBadges;

      isLoading.value = false;
    } catch (e) {
      errorMessage.value = 'Une erreur est survenue lors du chargement des données';
      isLoading.value = false;
      print('Erreur dans loadData: $e');
    }
  }

  // Version finale à utiliser quand l'API sera prête
  Future<void> loadDataFromApi() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Récupérer les informations du profil
      loadProfile();

      // Récupérer les cours
      final coursesResult = await _getCoursesUseCase.execute();
      courses.value = coursesResult;

      // Récupérer les badges
      final user = _storageService.user;
      if (user != null) {
        final params = GetBadgesByStudentParams(studentId: user.id);
        final badgesResult = await _getBadgesUseCase.execute(params);
        badges.value = badgesResult;
      }

      isLoading.value = false;
    } on AppException catch (e) {
      errorMessage.value = e.message ?? 'Une erreur est survenue';
      isLoading.value = false;
    } catch (e) {
      errorMessage.value = 'Une erreur inattendue est survenue';
      isLoading.value = false;
    }
  }

  // Charger les informations du profil depuis le stockage local ou MockData
  void loadProfile() {
    final user = _storageService.user;
    if (user != null) {
      profile.value = {
        'id': user.id,
        'firstName': user.firstName,
        'lastName': user.lastName,
        'email': user.email,
        'avatar': user.avatar,
        'role': user.role,
        // Ajouter d'autres informations si disponibles
        'level': _storageService.level ?? 1,
        'points': _storageService.points ?? 0,
        'streakDays': _storageService.streakDays ?? 0,
        'completedCourses': _storageService.completedCourses ?? 0,
        'completedExercises': _storageService.completedExercises ?? 0,
        'averageScore': _storageService.averageScore ?? 0,
      };
    } else {
      // Utiliser les données simulées pour le développement
      profile.value = MockData.studentProfile;
    }
  }
}