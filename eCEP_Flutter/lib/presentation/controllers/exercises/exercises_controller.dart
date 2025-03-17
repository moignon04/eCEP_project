import 'package:client/data/models/exercise.dart';
import 'package:client/data/providers/network/api_provider.dart';
import 'package:client/domain/usecases/exercise/get_all_exercises_usecase.dart';
import 'package:client/data/models/mock_data.dart'; // Importez vos données mockées
import 'package:get/get.dart';

class ExercisesController extends GetxController {
  final GetAllExercisesUseCase _getAllExercisesUseCase;

  ExercisesController({
    required GetAllExercisesUseCase getAllExercisesUseCase,
  }) : _getAllExercisesUseCase = getAllExercisesUseCase;

  final RxList<Exercise> exercises = <Exercise>[].obs;
  final RxList<Exercise> filteredExercises = <Exercise>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxString searchQuery = ''.obs;
  final RxInt selectedDifficulty = 0.obs;
  final RxBool showCompleted = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadExercises();

    // Réagir aux changements de recherche ou de filtres
    ever(searchQuery, (_) => filterExercises());
    ever(selectedDifficulty, (_) => filterExercises());
    ever(showCompleted, (_) => filterExercises());
  }

  // Charger tous les exercices
  Future<void> loadExercises() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _getAllExercisesUseCase.execute();

      // Si nous avons des résultats de l'API, utilisez-les
      if (result.isNotEmpty) {
        exercises.value = result;
      } else {
        // Sinon, utilisez les données mockées
        exercises.value = _loadMockExercises();
      }

      filterExercises();
    } on AppException catch (e) {
      errorMessage.value = e.message ?? 'Une erreur est survenue';
      // En cas d'erreur, utilisez les données mockées
      exercises.value = _loadMockExercises();
      filterExercises();
    } catch (e) {
      errorMessage.value = 'Une erreur inattendue est survenue';
      // En cas d'erreur, utilisez les données mockées
      exercises.value = _loadMockExercises();
      filterExercises();
    } finally {
      isLoading.value = false;
    }
  }

  // Charger les données mockées


  List<Exercise> _loadMockExercises() {
    // Créer et retourner quelques exercices mock directement
    return [
      Exercise(
        id: 1,
        title: "Reconnaître les fractions",
        type: "quiz",
        difficulty: 1,
        points: 10,
        isCompleted: true,
        score: 8,
        questions: [], // ou créer quelques questions si nécessaire
      ),
      Exercise(
        id: 2,
        title: "Addition de fractions",
        type: "interactive",
        difficulty: 2,
        points: 15,
        isCompleted: false,
        score: 0,
        questions: [],
      ),
      // Ajouter plus d'exercices mock au besoin
    ];
  }

  // Filtrer les exercices selon les critères
  void filterExercises() {
    if (searchQuery.isEmpty && selectedDifficulty.value == 0 && showCompleted.value) {
      filteredExercises.value = exercises;
      return;
    }

    List<Exercise> result = exercises;

    // Filtrer par recherche
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      result = result.where((exercise) {
        return exercise.title.toLowerCase().contains(query);
      }).toList();
    }

    // Filtrer par difficulté
    if (selectedDifficulty.value > 0) {
      result = result.where((exercise) {
        return exercise.difficulty == selectedDifficulty.value;
      }).toList();
    }

    // Filtrer par statut (complété ou non)
    if (!showCompleted.value) {
      result = result.where((exercise) {
        return !exercise.isCompleted;
      }).toList();
    }

    filteredExercises.value = result;
  }
}