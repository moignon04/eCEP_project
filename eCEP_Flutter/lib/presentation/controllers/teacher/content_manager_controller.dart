import 'package:get/get.dart';
import 'package:client/data/models/course.dart';
import 'package:client/data/models/mock_data.dart';
import 'package:client/app/extension/color.dart';
import 'package:flutter/material.dart';

class ContentManagerController extends GetxController {
  // États de l'interface
  final isLoading = true.obs;
  final selectedTabIndex = 0.obs;

  // Listes des contenus
  final courses = <Course>[].obs;
  final exercises = <Map<String, dynamic>>[].obs;
  final resources = <Map<String, dynamic>>[].obs;

  // Filtres
  final searchQuery = ''.obs;
  final selectedSubject = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    loadContent();
  }

  Future<void> loadContent() async {
    isLoading.value = true;

    try {
      // Simuler un délai réseau
      await Future.delayed(Duration(seconds: 1));

      // Charger les cours depuis les données simulées
      courses.value = MockData.courses.map((data) => Course.fromJson(data)).toList();

      // Générer des exercices simulés basés sur les cours
      final List<Map<String, dynamic>> exercisesList = [];
      for (var course in courses) {
        for (var chapter in course.chapters) {
          exercisesList.addAll(chapter.exercises.map((exercise) => {
            'id': exercise.id,
            'title': exercise.title,
            'type': exercise.type,
            'difficulty': exercise.difficulty,
            'courseName': course.title,
            'courseId': course.id,
            'subject': course.subject,
            'points': exercise.points,
            'isCompleted': exercise.isCompleted,
            'score': exercise.score,
            'isPublished': exercise.id % 2 == 0, // Simuler des exercices publiés et non publiés
            'dateCreated': '${10 + (exercise.id % 20)}/03/2024',
          }).toList());
        }
      }
      exercises.value = exercisesList;

      // Générer des ressources simulées
      resources.value = [
        {
          'id': 1,
          'title': 'Introduction aux fractions',
          'type': 'video',
          'fileSize': '24 MB',
          'subject': 'Mathématiques',
          'courseId': 1,
          'courseName': 'Les fractions',
          'lastUpdated': '15/03/2024',
          'isPublished': true,
          'downloads': 45,
        },
        {
          'id': 2,
          'title': 'Les verbes du premier groupe',
          'type': 'pdf',
          'fileSize': '3.2 MB',
          'subject': 'Français',
          'courseId': 2,
          'courseName': 'La conjugaison des verbes',
          'lastUpdated': '14/03/2024',
          'isPublished': true,
          'downloads': 28,
        },
        {
          'id': 3,
          'title': 'Le système digestif',
          'type': 'video',
          'fileSize': '35 MB',
          'subject': 'Sciences',
          'courseId': 4,
          'courseName': 'Le corps humain',
          'lastUpdated': '13/03/2024',
          'isPublished': true,
          'downloads': 32,
        },
        {
          'id': 4,
          'title': 'Christophe Colomb et les grandes découvertes',
          'type': 'audio',
          'fileSize': '12 MB',
          'subject': 'Histoire-Géographie',
          'courseId': 3,
          'courseName': 'Les grandes découvertes',
          'lastUpdated': '10/03/2024',
          'isPublished': false,
          'downloads': 0,
        },
        {
          'id': 5,
          'title': 'Exercices sur les fractions',
          'type': 'pdf',
          'fileSize': '1.8 MB',
          'subject': 'Mathématiques',
          'courseId': 1,
          'courseName': 'Les fractions',
          'lastUpdated': '08/03/2024',
          'isPublished': true,
          'downloads': 52,
        },
      ];

    } catch (e) {
      print('Erreur lors du chargement du contenu: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Filtrer les cours
  List<Course> get filteredCourses {
    if (searchQuery.isEmpty && selectedSubject.value == null) {
      return courses;
    }

    return courses.where((course) {
      bool matchesSearch = searchQuery.isEmpty ||
          course.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          course.description.toLowerCase().contains(searchQuery.value.toLowerCase());

      bool matchesSubject = selectedSubject.value == null ||
          course.subject == selectedSubject.value;

      return matchesSearch && matchesSubject;
    }).toList();
  }

  // Filtrer les exercices
  List<Map<String, dynamic>> get filteredExercises {
    if (searchQuery.isEmpty && selectedSubject.value == null) {
      return exercises;
    }

    return exercises.where((exercise) {
      bool matchesSearch = searchQuery.isEmpty ||
          exercise['title'].toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          exercise['courseName'].toLowerCase().contains(searchQuery.value.toLowerCase());

      bool matchesSubject = selectedSubject.value == null ||
          exercise['subject'] == selectedSubject.value;

      return matchesSearch && matchesSubject;
    }).toList();
  }

  // Filtrer les ressources
  List<Map<String, dynamic>> get filteredResources {
    if (searchQuery.isEmpty && selectedSubject.value == null) {
      return resources;
    }

    return resources.where((resource) {
      bool matchesSearch = searchQuery.isEmpty ||
          resource['title'].toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          resource['courseName'].toLowerCase().contains(searchQuery.value.toLowerCase());

      bool matchesSubject = selectedSubject.value == null ||
          resource['subject'] == selectedSubject.value;

      return matchesSearch && matchesSubject;
    }).toList();
  }

  // Obtenir la couleur en fonction du type de ressource
  Color getResourceTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'video':
        return Colors.blue;
      case 'pdf':
        return Colors.red;
      case 'audio':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  // Obtenir l'icône en fonction du type de ressource
  IconData getResourceTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'video':
        return Icons.videocam;
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'audio':
        return Icons.audiotrack;
      default:
        return Icons.insert_drive_file;
    }
  }

  // Publier ou dépublier une ressource
  void toggleResourcePublishStatus(int resourceId) {
    final index = resources.indexWhere((r) => r['id'] == resourceId);
    if (index != -1) {
      final resource = Map<String, dynamic>.from(resources[index]);
      resource['isPublished'] = !resource['isPublished'];
      resources[index] = resource;

      Get.snackbar(
        resource['isPublished'] ? 'Ressource publiée' : 'Ressource dépubliée',
        resource['isPublished']
            ? 'La ressource "${resource['title']}" est maintenant visible par les élèves.'
            : 'La ressource "${resource['title']}" n\'est plus visible par les élèves.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Publier ou dépublier un exercice
  void toggleExercisePublishStatus(int exerciseId) {
    final index = exercises.indexWhere((e) => e['id'] == exerciseId);
    if (index != -1) {
      final exercise = Map<String, dynamic>.from(exercises[index]);
      exercise['isPublished'] = !exercise['isPublished'];
      exercises[index] = exercise;

      Get.snackbar(
        exercise['isPublished'] ? 'Exercice publié' : 'Exercice dépublié',
        exercise['isPublished']
            ? 'L\'exercice "${exercise['title']}" est maintenant visible par les élèves.'
            : 'L\'exercice "${exercise['title']}" n\'est plus visible par les élèves.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Supprimer une ressource
  void deleteResource(int resourceId) {
    final index = resources.indexWhere((r) => r['id'] == resourceId);
    if (index != -1) {
      final resourceTitle = resources[index]['title'];
      resources.removeAt(index);

      Get.snackbar(
        'Ressource supprimée',
        'La ressource "$resourceTitle" a été supprimée.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Supprimer un exercice
  void deleteExercise(int exerciseId) {
    final index = exercises.indexWhere((e) => e['id'] == exerciseId);
    if (index != -1) {
      final exerciseTitle = exercises[index]['title'];
      exercises.removeAt(index);

      Get.snackbar(
        'Exercice supprimé',
        'L\'exercice "$exerciseTitle" a été supprimé.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Créer un nouveau cours (simulé)
  void createNewCourse() {
    Get.toNamed('/create-course');
  }

  // Créer un nouvel exercice (simulé)
  void createNewExercise() {
    Get.toNamed('/create-exercise');
  }

  // Ajouter une nouvelle ressource (simulé)
  void addNewResource() {
    Get.toNamed('/add-resource');
  }
}