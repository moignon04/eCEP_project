import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class CreateCourseController extends GetxController {
  // Contrôleurs de texte
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  // Variables observables
  final isLoading = false.obs;
  final isSaving = false.obs;
  final selectedSubject = 'Mathématiques'.obs;
  final courseImage = ''.obs;
  final isDownloadable = false.obs;

  // Liste des chapitres
  final chapters = <Map<String, dynamic>>[].obs;

  // Index du chapitre actuellement édité
  final currentChapterIndex = (-1).obs;

  // Types de médias disponibles
  final mediaTypes = ['Video', 'Audio', 'PDF', 'Text'].obs;

  // Liste des sujets disponibles
  final subjects = [
    'Mathématiques',
    'Français',
    'Histoire-Géographie',
    'Sciences'
  ].obs;

  // Durée totale estimée (en minutes)
  final estimatedDuration = 0.obs;

  // Nombre total de leçons et d'exercices
  final totalLessons = 0.obs;
  final totalExercises = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Ajouter un chapitre par défaut
    addChapter();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  // Ajouter un nouveau chapitre
  void addChapter() {
    final uuid = Uuid();
    chapters.add({
      'id': uuid.v4(),
      'title': 'Chapitre ${chapters.length + 1}',
      'lessons': <Map<String, dynamic>>[],
      'exercises': <Map<String, dynamic>>[]
    });
    updateTotals();
  }

  // Supprimer un chapitre
  void removeChapter(int index) {
    if (index >= 0 && index < chapters.length) {
      Get.dialog(
        AlertDialog(
          title: Text('Supprimer le chapitre'),
          content: Text(
              'Êtes-vous sûr de vouloir supprimer ce chapitre et tout son contenu ?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                chapters.removeAt(index);
                Get.back();
                updateTotals();
              },
              child: Text('Supprimer'),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
          ],
        ),
      );
    }
  }

  // Modifier le titre d'un chapitre
  void updateChapterTitle(int index, String newTitle) {
    if (index >= 0 && index < chapters.length) {
      chapters[index]['title'] = newTitle;
      chapters.refresh();
    }
  }

  // Ajouter une leçon à un chapitre
  void addLesson(int chapterIndex) {
    if (chapterIndex >= 0 && chapterIndex < chapters.length) {
      final uuid = Uuid();
      final lessons = chapters[chapterIndex]['lessons'] as List<
          Map<String, dynamic>>;
      lessons.add({
        'id': uuid.v4(),
        'title': 'Leçon ${lessons.length + 1}',
        'type': 'Text',
        'duration': 15, // Durée par défaut en minutes
        'content': '',
        'isCompleted': false
      });
      chapters.refresh();
      updateTotals();
    }
  }

  // Supprimer une leçon d'un chapitre
  void removeLesson(int chapterIndex, int lessonIndex) {
    if (chapterIndex >= 0 && chapterIndex < chapters.length) {
      final lessons = chapters[chapterIndex]['lessons'] as List<
          Map<String, dynamic>>;
      if (lessonIndex >= 0 && lessonIndex < lessons.length) {
        Get.dialog(
          AlertDialog(
            title: Text('Supprimer la leçon'),
            content: Text('Êtes-vous sûr de vouloir supprimer cette leçon ?'),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text('Annuler'),
              ),
              TextButton(
                onPressed: () {
                  lessons.removeAt(lessonIndex);
                  chapters.refresh();
                  Get.back();
                  updateTotals();
                },
                child: Text('Supprimer'),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
              ),
            ],
          ),
        );
      }
    }
  }

  // Ajouter un exercice à un chapitre
  void addExercise(int chapterIndex) {
    if (chapterIndex >= 0 && chapterIndex < chapters.length) {
      final uuid = Uuid();
      final exercises = chapters[chapterIndex]['exercises'] as List<
          Map<String, dynamic>>;
      exercises.add({
        'id': uuid.v4(),
        'title': 'Exercice ${exercises.length + 1}',
        'type': 'quiz',
        'difficulty': 1,
        'points': 10,
        'questions': <Map<String, dynamic>>[]
      });
      chapters.refresh();
      updateTotals();
    }
  }

  // Supprimer un exercice d'un chapitre
  void removeExercise(int chapterIndex, int exerciseIndex) {
    if (chapterIndex >= 0 && chapterIndex < chapters.length) {
      final exercises = chapters[chapterIndex]['exercises'] as List<
          Map<String, dynamic>>;
      if (exerciseIndex >= 0 && exerciseIndex < exercises.length) {
        Get.dialog(
          AlertDialog(
            title: Text('Supprimer l\'exercice'),
            content: Text('Êtes-vous sûr de vouloir supprimer cet exercice ?'),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text('Annuler'),
              ),
              TextButton(
                onPressed: () {
                  exercises.removeAt(exerciseIndex);
                  chapters.refresh();
                  Get.back();
                  updateTotals();
                },
                child: Text('Supprimer'),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
              ),
            ],
          ),
        );
      }
    }
  }

  // Éditer les détails d'une leçon
  void editLesson(int chapterIndex, int lessonIndex,
      Map<String, dynamic> newData) {
    if (chapterIndex >= 0 && chapterIndex < chapters.length) {
      final lessons = chapters[chapterIndex]['lessons'] as List<
          Map<String, dynamic>>;
      if (lessonIndex >= 0 && lessonIndex < lessons.length) {
        lessons[lessonIndex] = {
          ...lessons[lessonIndex],
          ...newData
        };
        chapters.refresh();
        updateTotals();
      }
    }
  }

  // Éditer les détails d'un exercice
  void editExercise(int chapterIndex, int exerciseIndex,
      Map<String, dynamic> newData) {
    if (chapterIndex >= 0 && chapterIndex < chapters.length) {
      final exercises = chapters[chapterIndex]['exercises'] as List<
          Map<String, dynamic>>;
      if (exerciseIndex >= 0 && exerciseIndex < exercises.length) {
        exercises[exerciseIndex] = {
          ...exercises[exerciseIndex],
          ...newData
        };
        chapters.refresh();
      }
    }
  }

  // Mettre à jour les totaux (leçons, exercices, durée)
  void updateTotals() {
    int lessons = 0;
    int exercises = 0;
    int duration = 0;

    for (var chapter in chapters) {
      lessons += (chapter['lessons'] as List).length;
      exercises += (chapter['exercises'] as List).length;

      for (var lesson in chapter['lessons']) {
        duration += lesson['duration'] as int;
      }
    }

    totalLessons.value = lessons;
    totalExercises.value = exercises;
    estimatedDuration.value = duration;
  }

  // Choisir une image pour le cours
  Future<void> pickImage() async {
    // Simulation de la sélection d'image
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 1));
    courseImage.value =
    'assets/images/${selectedSubject.value.toLowerCase()}.png';
    isLoading.value = false;
  }

  // Valider que toutes les informations nécessaires sont présentes
  bool validateCourse() {
    if (titleController.text.isEmpty) {
      Get.snackbar(
        'Erreur',
        'Le titre du cours est obligatoire',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (descriptionController.text.isEmpty) {
      Get.snackbar(
        'Erreur',
        'La description du cours est obligatoire',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (courseImage.value.isEmpty) {
      Get.snackbar(
        'Erreur',
        'Une image est requise pour le cours',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (chapters.isEmpty) {
      Get.snackbar(
        'Erreur',
        'Le cours doit contenir au moins un chapitre',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    // Vérifier que chaque chapitre a au moins une leçon ou un exercice
    for (int i = 0; i < chapters.length; i++) {
      final chapter = chapters[i];
      if ((chapter['lessons'] as List).isEmpty &&
          (chapter['exercises'] as List).isEmpty) {
        Get.snackbar(
          'Erreur',
          'Le chapitre ${i +
              1} doit contenir au moins une leçon ou un exercice',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    }

    return true;
  }

  // Sauvegarder le cours
  Future<void> saveCourse() async {
    if (!validateCourse()) {
      return;
    }

    isSaving.value = true;

    try {
      // Simuler l'enregistrement du cours
      await Future.delayed(Duration(seconds: 2));

      final uuid = Uuid();
      final courseData = {
        'id': uuid.v4(),
        'title': titleController.text,
        'subject': selectedSubject.value,
        'description': descriptionController.text,
        'progress': 0,
        'image': courseImage.value,
        'isDownloaded': false,
        'chapters': chapters.toList(),
        'teacherName': 'Marie Durant',
        // À remplacer par les données de l'enseignant connecté
        'totalLessons': totalLessons.value,
        'totalExercises': totalExercises.value,
        'created_at': DateTime.now().toIso8601String(),
      };

      // Dans une implémentation réelle, envoyer les données à l'API
      // await courseService.createCourse(courseData);

      Get.back(result: courseData);

      Get.snackbar(
        'Succès',
        'Le cours a été créé avec succès',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Une erreur est survenue lors de la création du cours: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSaving.value = false;
    }
  }

  // Sauvegarder le cours comme brouillon
  Future<void> saveDraft() async {
    isSaving.value = true;

    try {
      // Simuler l'enregistrement du brouillon
      await Future.delayed(Duration(seconds: 1));

      final uuid = Uuid();
      final draftData = {
        'id': uuid.v4(),
        'title': titleController.text.isEmpty ? 'Brouillon' : titleController
            .text,
        'subject': selectedSubject.value,
        'description': descriptionController.text,
        'image': courseImage.value,
        'chapters': chapters.toList(),
        'isDraft': true,
        'lastSaved': DateTime.now().toIso8601String(),
      };

      // Dans une implémentation réelle, sauvegarder le brouillon localement ou sur le serveur
      // await draftService.saveDraft(draftData);

      Get.snackbar(
        'Brouillon sauvegardé',
        'Votre progression a été sauvegardée',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Une erreur est survenue lors de la sauvegarde du brouillon: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSaving.value = false;
    }
  }

  // Ajouter une question à un exercice
  void addQuestion(int chapterIndex, int exerciseIndex) {
    if (chapterIndex >= 0 && chapterIndex < chapters.length) {
      final exercises = chapters[chapterIndex]['exercises'] as List<
          Map<String, dynamic>>;
      if (exerciseIndex >= 0 && exerciseIndex < exercises.length) {
        final uuid = Uuid();
        final questions = exercises[exerciseIndex]['questions'] as List<
            Map<String, dynamic>>;
        questions.add({
          'id': uuid.v4(),
          'text': 'Question ${questions.length + 1}',
          'type': 'qcm',
          'choices': [
            {'id': 'a', 'text': 'Option A'},
            {'id': 'b', 'text': 'Option B'},
            {'id': 'c', 'text': 'Option C'},
          ],
          'correctAnswer': 'a'
        });
        chapters.refresh();
      }
    }
  }

  // Supprimer une question d'un exercice
  void removeQuestion(int chapterIndex, int exerciseIndex, int questionIndex) {
    if (chapterIndex >= 0 && chapterIndex < chapters.length) {
      final exercises = chapters[chapterIndex]['exercises'] as List<
          Map<String, dynamic>>;
      if (exerciseIndex >= 0 && exerciseIndex < exercises.length) {
        final questions = exercises[exerciseIndex]['questions'] as List<
            Map<String, dynamic>>;
        if (questionIndex >= 0 && questionIndex < questions.length) {
          questions.removeAt(questionIndex);
          chapters.refresh();
        }
      }
    }
  }

  // Prévisualiser le cours
  void previewCourse() {
    if (!validateCourse()) {
      return;
    }

    final previewData = {
      'title': titleController.text,
      'subject': selectedSubject.value,
      'description': descriptionController.text,
      'image': courseImage.value,
      'isDownloaded': false,
      'chapters': chapters.toList(),
      'teacherName': 'Marie Durant',
      // À remplacer par les données de l'enseignant connecté
      'totalLessons': totalLessons.value,
      'totalExercises': totalExercises.value,
      'progress': 0,
    };

    // Naviguer vers la page de prévisualisation
    Get.toNamed('/course-preview', arguments: previewData);
  }
}