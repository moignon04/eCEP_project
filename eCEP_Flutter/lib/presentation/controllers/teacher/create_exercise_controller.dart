import 'package:get/get.dart';
import 'package:client/data/models/course.dart';
import 'package:client/data/models/mock_data.dart';
import 'package:flutter/material.dart';

class CreateExerciseController extends GetxController {
  // États de l'interface
  final isLoading = true.obs;
  final isSaving = false.obs;
  final isEdit = false.obs;

  // Données de l'exercice
  final exerciseId = 0.obs;
  final title = ''.obs;
  final type = 'quiz'.obs;
  final difficulty = 1.obs;
  final points = 10.obs;
  final selectedCourseId = 0.obs;
  final selectedChapterId = 0.obs;
  final isPublished = false.obs;

  // Questions et choix
  final questions = <Map<String, dynamic>>[].obs;

  // Liste des cours disponibles
  final availableCourses = <Course>[].obs;
  final availableChapters = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();

    // Vérifier si nous sommes en mode édition
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      isEdit.value = true;
      loadExerciseData(Get.arguments);
    }

    loadCourses();
  }

  void loadExerciseData(Map<String, dynamic> exerciseData) {
    exerciseId.value = exerciseData['id'] ?? 0;
    title.value = exerciseData['title'] ?? '';
    type.value = exerciseData['type'] ?? 'quiz';
    difficulty.value = exerciseData['difficulty'] ?? 1;
    points.value = exerciseData['points'] ?? 10;
    selectedCourseId.value = exerciseData['courseId'] ?? 0;
    isPublished.value = exerciseData['isPublished'] ?? false;

    // Charger les questions si disponibles
    if (exerciseData['questions'] != null && exerciseData['questions'] is List) {
      questions.value = exerciseData['questions'].map<Map<String, dynamic>>((q) => {
        'id': q['id'] ?? 0,
        'text': q['text'] ?? '',
        'type': q['type'] ?? 'choice',
        'choices': q['choices'] ?? [],
        'correctAnswer': q['correctAnswer'] ?? '',
      }).toList();
    } else {
      // Créer une question par défaut pour un nouvel exercice en édition
      questions.value = [_createDefaultQuestion()];
    }
  }

  Future<void> loadCourses() async {
    isLoading.value = true;

    try {
      // Simuler un délai réseau
      await Future.delayed(Duration(seconds: 1));

      // Charger les cours depuis les données simulées
      availableCourses.value = MockData.courses.map((data) => Course.fromJson(data)).toList();

      // Si nous sommes en mode édition et qu'un cours est sélectionné, charger les chapitres
      if (isEdit.value && selectedCourseId.value > 0) {
        updateAvailableChapters();
      } else if (availableCourses.isNotEmpty) {
        // Si c'est un nouvel exercice, sélectionner le premier cours par défaut
        selectedCourseId.value = availableCourses.first.id;
        updateAvailableChapters();
      }

    } catch (e) {
      print('Erreur lors du chargement des cours: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void updateAvailableChapters() {
    final course = availableCourses.firstWhere(
          (c) => c.id == selectedCourseId.value,
      orElse: () => availableCourses.first,
    );

    availableChapters.value = course.chapters.map((chapter) => {
      'id': chapter.id,
      'title': chapter.title,
    }).toList();

    if (availableChapters.isNotEmpty && selectedChapterId.value == 0) {
      selectedChapterId.value = availableChapters.first['id'];
    }
  }

  void onCourseChanged(int? courseId) {
    if (courseId != null && courseId != selectedCourseId.value) {
      selectedCourseId.value = courseId;
      updateAvailableChapters();
    }
  }

  void onChapterChanged(int? chapterId) {
    if (chapterId != null) {
      selectedChapterId.value = chapterId;
    }
  }

  void addQuestion() {
    questions.add(_createDefaultQuestion());
  }

  Map<String, dynamic> _createDefaultQuestion() {
    return {
      'id': DateTime.now().millisecondsSinceEpoch,
      'text': '',
      'type': 'choice',
      'choices': [
        {'id': '1', 'text': ''},
        {'id': '2', 'text': ''},
      ],
      'correctAnswer': '1',
    };
  }

  void removeQuestion(int index) {
    if (questions.length > 1) {
      questions.removeAt(index);
    } else {
      Get.snackbar(
        'Impossible de supprimer',
        'Un exercice doit avoir au moins une question.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void updateQuestionText(int index, String text) {
    if (index < questions.length) {
      final question = Map<String, dynamic>.from(questions[index]);
      question['text'] = text;
      questions[index] = question;
    }
  }

  void updateQuestionType(int index, String type) {
    if (index < questions.length) {
      final question = Map<String, dynamic>.from(questions[index]);
      question['type'] = type;

      // Si le type change vers texte libre, ajuster les choix
      if (type == 'text') {
        question['choices'] = [];
      } else if (question['choices'].isEmpty) {
        // Si le type change de texte vers QCM, ajouter des choix par défaut
        question['choices'] = [
          {'id': '1', 'text': ''},
          {'id': '2', 'text': ''},
        ];
        question['correctAnswer'] = '1';
      }

      questions[index] = question;
    }
  }

  void addChoice(int questionIndex) {
    if (questionIndex < questions.length) {
      final question = Map<String, dynamic>.from(questions[questionIndex]);
      final choices = List<Map<String, String>>.from(question['choices']);
      final newId = (choices.length + 1).toString();

      choices.add({'id': newId, 'text': ''});
      question['choices'] = choices;
      questions[questionIndex] = question;
    }
  }

  void removeChoice(int questionIndex, int choiceIndex) {
    if (questionIndex < questions.length) {
      final question = Map<String, dynamic>.from(questions[questionIndex]);
      final choices = List<Map<String, String>>.from(question['choices']);

      if (choices.length > 2) {
        final removedChoiceId = choices[choiceIndex]['id'];
        choices.removeAt(choiceIndex);

        // Si la réponse correcte était celle supprimée, réinitialiser à la première
        if (question['correctAnswer'] == removedChoiceId) {
          question['correctAnswer'] = choices.first['id'];
        }

        question['choices'] = choices;
        questions[questionIndex] = question;
      } else {
        Get.snackbar(
          'Impossible de supprimer',
          'Une question à choix multiples doit avoir au moins deux options.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  void updateChoiceText(int questionIndex, int choiceIndex, String text) {
    if (questionIndex < questions.length) {
      final question = Map<String, dynamic>.from(questions[questionIndex]);
      final choices = List<Map<String, String>>.from(question['choices']);

      if (choiceIndex < choices.length) {
        choices[choiceIndex] = {
          'id': choices[choiceIndex]['id'] ?? '',
          'text': text,
        };

        question['choices'] = choices;
        questions[questionIndex] = question;
      }
    }
  }

  void setCorrectAnswer(int questionIndex, String choiceId) {
    if (questionIndex < questions.length) {
      final question = Map<String, dynamic>.from(questions[questionIndex]);
      question['correctAnswer'] = choiceId;
      questions[questionIndex] = question;
    }
  }

  void updateTextAnswer(int questionIndex, String answer) {
    if (questionIndex < questions.length) {
      final question = Map<String, dynamic>.from(questions[questionIndex]);
      question['correctAnswer'] = answer;
      questions[questionIndex] = question;
    }
  }

  bool validateExercise() {
    if (title.value.isEmpty) {
      Get.snackbar(
        'Titre manquant',
        'Veuillez saisir un titre pour l\'exercice.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (selectedCourseId.value == 0) {
      Get.snackbar(
        'Cours manquant',
        'Veuillez sélectionner un cours.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (selectedChapterId.value == 0) {
      Get.snackbar(
        'Chapitre manquant',
        'Veuillez sélectionner un chapitre.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (questions.isEmpty) {
      Get.snackbar(
        'Questions manquantes',
        'Veuillez ajouter au moins une question.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    for (int i = 0; i < questions.length; i++) {
      final question = questions[i];

      if (question['text'].isEmpty) {
        Get.snackbar(
          'Question incomplète',
          'La question ${i + 1} n\'a pas de texte.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }

      if (question['type'] == 'choice') {
        if (question['choices'].isEmpty || question['choices'].length < 2) {
          Get.snackbar(
            'Choix manquants',
            'La question ${i + 1} doit avoir au moins deux choix.',
            snackPosition: SnackPosition.BOTTOM,
          );
          return false;
        }

        for (int j = 0; j < question['choices'].length; j++) {
          if (question['choices'][j]['text'].isEmpty) {
            Get.snackbar(
              'Choix incomplet',
              'Le choix ${j + 1} de la question ${i + 1} n\'a pas de texte.',
              snackPosition: SnackPosition.BOTTOM,
            );
            return false;
          }
        }

        if (question['correctAnswer'].isEmpty) {
          Get.snackbar(
            'Réponse correcte manquante',
            'Veuillez sélectionner la réponse correcte pour la question ${i + 1}.',
            snackPosition: SnackPosition.BOTTOM,
          );
          return false;
        }
      } else if (question['type'] == 'text') {
        if (question['correctAnswer'].isEmpty) {
          Get.snackbar(
            'Réponse correcte manquante',
            'Veuillez saisir la réponse correcte pour la question ${i + 1}.',
            snackPosition: SnackPosition.BOTTOM,
          );
          return false;
        }
      }
    }

    return true;
  }

  Future<void> saveExercise() async {
    if (!validateExercise()) {
      return;
    }

    isSaving.value = true;

    try {
      // Simuler un délai réseau
      await Future.delayed(Duration(seconds: 1));

      // Dans une application réelle, envoyer les données à l'API

      Get.snackbar(
        isEdit.value ? 'Exercice mis à jour' : 'Exercice créé',
        isEdit.value
            ? 'L\'exercice a été mis à jour avec succès.'
            : 'L\'exercice a été créé avec succès.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Retourner à la page précédente
      Get.back();

    } catch (e) {
      print('Erreur lors de la sauvegarde de l\'exercice: $e');
      Get.snackbar(
        'Erreur',
        'Une erreur est survenue lors de la sauvegarde de l\'exercice.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSaving.value = false;
    }
  }
}