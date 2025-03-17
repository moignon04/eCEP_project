import 'package:client/data/models/exercise.dart';
import 'package:client/data/models/question.dart';
import 'package:client/data/providers/network/api_provider.dart';
import 'package:client/domain/usecases/exercise/get_exercise_by_id_usecase.dart';
import 'package:client/domain/usecases/exercise/submit_exercise_usecase.dart';
import 'package:get/get.dart';

class ExerciseDetailController extends GetxController {
  final GetExerciseByIdUseCase _getExerciseByIdUseCase;
  final SubmitExerciseUseCase _submitExerciseUseCase;

  ExerciseDetailController({
    required GetExerciseByIdUseCase getExerciseByIdUseCase,
    required SubmitExerciseUseCase submitExerciseUseCase,
  })  : _getExerciseByIdUseCase = getExerciseByIdUseCase,
        _submitExerciseUseCase = submitExerciseUseCase;

  final Rx<Exercise> exercise = Exercise(
    id: 0,
    title: '',
    type: '',
    difficulty: 1,
    points: 0,
    isCompleted: false,
    score: 0,
    questions: [],
  ).obs;

  final RxBool isLoading = true.obs;
  final RxBool isSubmitting = false.obs;
  final RxString errorMessage = ''.obs;

  // Stocker les réponses de l'utilisateur
  final RxMap<String, dynamic> userAnswers = <String, dynamic>{}.obs;

  // Stocker les résultats
  final Rx<Map<String, dynamic>?> result = Rx<Map<String, dynamic>?>(null);

  @override
  void onInit() {
    super.onInit();
    // Récupérer l'exercice à partir des arguments de Get
    final exerciseArg = Get.arguments;
    if (exerciseArg is Exercise) {
      exercise.value = exerciseArg;
      loadExerciseDetails(exerciseArg.id);
    } else if (exerciseArg is int) {
      loadExerciseDetails(exerciseArg);
    }
  }

  // Charger les détails d'un exercice
  Future<void> loadExerciseDetails(int id) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final params = GetExerciseByIdParams(id: id);
      final exerciseDetails = await _getExerciseByIdUseCase.execute(params);
      exercise.value = exerciseDetails;

      // Initialiser les réponses pour chaque question
      for (Question question in exerciseDetails.questions) {
        userAnswers[question.id.toString()] = null;
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

  // Enregistrer la réponse d'un utilisateur à une question
  void setAnswer(String questionId, dynamic answer) {
    userAnswers[questionId] = answer;
  }

  // Soumettre l'exercice
  Future<bool> submitExercise() async {
    isSubmitting.value = true;
    errorMessage.value = '';
    result.value = null;

    try {
      final params = SubmitExerciseParams(
        exerciseId: exercise.value.id,
        answers: userAnswers,
      );

      final submissionResult = await _submitExerciseUseCase.execute(params);
      result.value = submissionResult;

      // Mettre à jour l'exercice avec le statut complet et le score
      exercise.update((val) {
        val?.isCompleted = true;
        val?.score = submissionResult['score'] ?? 0;
      });

      isSubmitting.value = false;
      return true;
    } on AppException catch (e) {
      errorMessage.value = e.message ?? 'Une erreur est survenue';
      isSubmitting.value = false;
      return false;
    } catch (e) {
      errorMessage.value = 'Une erreur inattendue est survenue';
      isSubmitting.value = false;
      return false;
    }
  }
}