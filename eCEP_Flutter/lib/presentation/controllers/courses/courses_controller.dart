import 'package:client/data/models/course.dart';
import 'package:client/data/providers/network/api_provider.dart';
import 'package:client/domain/usecases/course/get_all_courses_usecase.dart';
import 'package:client/domain/usecases/course/search_courses_usecase.dart';
import 'package:get/get.dart';
import 'package:client/data/models/mock_data.dart'; // Importez vos données mockées

class CoursesController extends GetxController {
  final GetAllCoursesUseCase _getAllCoursesUseCase;
  final SearchCoursesUseCase _searchCoursesUseCase;

  CoursesController({
    required GetAllCoursesUseCase getAllCoursesUseCase,
    required SearchCoursesUseCase searchCoursesUseCase,
  })  : _getAllCoursesUseCase = getAllCoursesUseCase,
        _searchCoursesUseCase = searchCoursesUseCase;

  final RxList<Course> courses = <Course>[].obs;
  final RxList<Course> filteredCourses = <Course>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxString searchQuery = ''.obs;
  final Rx<String?> selectedSubject = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    loadCourses();

    // Réagir aux changements de recherche ou de filtres
    ever(searchQuery, (_) => filterCourses());
    ever(selectedSubject, (_) => filterCourses());
  }

  // Charger tous les cours
  Future<void> loadCourses() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _getAllCoursesUseCase.execute();

      // Si nous avons des résultats de l'API, utilisez-les
      if (result.isNotEmpty) {
        courses.value = result;
      } else {
        // Sinon, utilisez les données mockées
        courses.value = _loadMockCourses();
      }

      filterCourses();
    } on AppException catch (e) {
      errorMessage.value = e.message ?? 'Une erreur est survenue';
      // En cas d'erreur, utilisez également les données mockées
      courses.value = _loadMockCourses();
      filterCourses();
    } catch (e) {
      errorMessage.value = 'Une erreur inattendue est survenue';
      // En cas d'erreur, utilisez également les données mockées
      courses.value = _loadMockCourses();
      filterCourses();
    } finally {
      isLoading.value = false;
    }
  }

  // Charger les données mockées
  List<Course> _loadMockCourses() {
    // Convertir les données mockées en objets Course
    return MockData.courses.map((courseData) => Course.fromJson(courseData)).toList();
  }

  // Filtrer les cours selon les critères
  void filterCourses() {
    if (searchQuery.isEmpty && selectedSubject.value == null) {
      filteredCourses.value = courses;
      return;
    }

    List<Course> result = courses;

    // Filtrer par recherche
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      result = result.where((course) {
        return course.title.toLowerCase().contains(query) ||
            course.description.toLowerCase().contains(query);
      }).toList();
    }

    // Filtrer par matière
    if (selectedSubject.value != null) {
      result = result.where((course) {
        return course.subject.toLowerCase() == selectedSubject.value!.toLowerCase();
      }).toList();
    }

    filteredCourses.value = result;
  }

  // Rechercher des cours
  Future<void> searchCourses(String query) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final params = SearchCoursesParams(query: query);
      final result = await _searchCoursesUseCase.execute(params);

      // Si nous avons des résultats de recherche, utilisez-les
      if (result.isNotEmpty) {
        courses.value = result;
      } else {
        // Sinon, filtrer les données mockées selon la requête
        List<Course> mockCourses = _loadMockCourses();
        courses.value = mockCourses.where((course) {
          return course.title.toLowerCase().contains(query.toLowerCase()) ||
              course.description.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }

      filterCourses();
    } on AppException catch (e) {
      errorMessage.value = e.message ?? 'Une erreur est survenue';
      // En cas d'erreur, filtrer les données mockées
      List<Course> mockCourses = _loadMockCourses();
      courses.value = mockCourses.where((course) {
        return course.title.toLowerCase().contains(query.toLowerCase()) ||
            course.description.toLowerCase().contains(query.toLowerCase());
      }).toList();
      filterCourses();
    } catch (e) {
      errorMessage.value = 'Une erreur inattendue est survenue';
      // En cas d'erreur, filtrer les données mockées
      List<Course> mockCourses = _loadMockCourses();
      courses.value = mockCourses.where((course) {
        return course.title.toLowerCase().contains(query.toLowerCase()) ||
            course.description.toLowerCase().contains(query.toLowerCase());
      }).toList();
      filterCourses();
    } finally {
      isLoading.value = false;
    }
  }
}