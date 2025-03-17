import 'package:client/data/models/course.dart';
import 'package:client/data/providers/network/api_provider.dart';
import 'package:client/domain/usecases/course/get_course_by_id_usecase.dart';
import 'package:get/get.dart';

class CourseDetailController extends GetxController {
  final GetCourseByIdUseCase _getCourseByIdUseCase;

  CourseDetailController({
    required GetCourseByIdUseCase getCourseByIdUseCase,
  }) : _getCourseByIdUseCase = getCourseByIdUseCase;

  final Rx<Course> course = Course(
    id: 0,
    title: '',
    subject: '',
    description: '',
    progress: 0,
    image: '',
    isDownloaded: false,
    chapters: [],
    teacherName: '',
    totalLessons: 0,
    totalExercises: 0,
  ).obs;

  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isExpanded = false.obs;
  final RxInt selectedTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Récupérer le cours à partir des arguments de Get
    final courseArg = Get.arguments;
    if (courseArg is Course) {
      course.value = courseArg;
      loadCourseDetails(courseArg.id);
    } else if (courseArg is int) {
      loadCourseDetails(courseArg);
    }
  }

  // Charger les détails d'un cours
  Future<void> loadCourseDetails(int id) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final params = GetCourseByIdParams(id: id);
      final courseDetails = await _getCourseByIdUseCase.execute(params);
      course.value = courseDetails;
      isLoading.value = false;
    } on AppException catch (e) {
      errorMessage.value = e.message ?? 'Une erreur est survenue';
      isLoading.value = false;
    } catch (e) {
      errorMessage.value = 'Une erreur inattendue est survenue';
      isLoading.value = false;
    }
  }

  // Étendre ou réduire la description
  void toggleDescription() {
    isExpanded.value = !isExpanded.value;
  }

  // Télécharger le cours pour une utilisation hors ligne
  void downloadCourse() {
    // Logique pour télécharger le cours
    // Cette implémentation pourrait utiliser un service de téléchargement
    course.update((val) {
      val?.isDownloaded = true;
    });

    Get.snackbar(
      'Téléchargement',
      'Le cours a été téléchargé pour une utilisation hors ligne',
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 3),
    );
  }
}