import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:just_audio/just_audio.dart';
import 'package:client/data/models/lesson.dart';
import 'package:client/data/models/course.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class CoursePlayerController extends GetxController {
  // Leçon actuelle
  final lesson = Lesson(
    id: 0,
    title: '',
    type: '',
    duration: 0,
    content: '',
    isCompleted: false,
  ).obs;

  // Contrôleurs de lecture
  Rx<VideoPlayerController?> videoController = Rx<VideoPlayerController?>(null);
  Rx<ChewieController?> chewieController = Rx<ChewieController?>(null);
  final audioPlayer = AudioPlayer();

  // États d'interface
  final isLoading = true.obs;
  final isFavorite = false.obs;
  final isPlaying = false.obs;
  final currentPosition = 0.obs;
  final totalDuration = 1.obs; // Éviter la division par zéro

  // Navigation entre leçons
  final previousLesson = Rx<Lesson?>(null);
  final nextLesson = Rx<Lesson?>(null);
  final relatedLessons = <Lesson>[].obs;

  // Course auquel appartient la leçon
  Rx<Course?> parentCourse = Rx<Course?>(null);

  @override
  void onInit() {
    super.onInit();

    // Récupérer les arguments passés
    if (Get.arguments is Map) {
      if (Get.arguments['lesson'] != null) {
        lesson.value = Get.arguments['lesson'];
      }
      if (Get.arguments['course'] != null) {
        parentCourse.value = Get.arguments['course'];
      }
    } else if (Get.arguments is Lesson) {
      lesson.value = Get.arguments;
    }

    loadLessonContent();
  }

  @override
  void onClose() {
    // Libérer les ressources
    videoController.value?.dispose();
    chewieController.value?.dispose();
    audioPlayer.dispose();
    super.onClose();
  }

  void loadLessonContent() async {
    isLoading.value = true;

    try {
      // Simuler une charge réseau
      await Future.delayed(Duration(seconds: 1));

      // Charger le contenu selon le type
      switch (lesson.value.type.toLowerCase()) {
        case 'video':
          await initVideoPlayer();
          break;
        case 'audio':
          await initAudioPlayer();
          break;
      }

      // Charger les leçons adjacentes et connexes
      loadAdjacentLessons();
      loadRelatedLessons();

      // Vérifier si la leçon est en favori
      checkFavoriteStatus();

    } catch (e) {
      print('Erreur lors du chargement de la leçon: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> initVideoPlayer() async {
    try {
      // Dans une application réelle, utiliser l'URL provenant du modèle
      // Pour la démo, nous utilisons une vidéo de test
      final videoUrl = 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

      videoController.value = VideoPlayerController.network(videoUrl);
      await videoController.value!.initialize();

      chewieController.value = ChewieController(
        videoPlayerController: videoController.value!,
        autoPlay: true,
        looping: false,
        showControls: true,
        aspectRatio: 16 / 9,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              'Erreur de lecture: $errorMessage',
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      );

      // Mise à jour de la durée
      totalDuration.value = videoController.value!.value.duration.inSeconds;

      // Écouter la position actuelle
      videoController.value!.addListener(() {
        if (videoController.value!.value.isPlaying) {
          currentPosition.value = videoController.value!.value.position.inSeconds;
        }
      });
    } catch (e) {
      print('Erreur lors de l\'initialisation du lecteur vidéo: $e');
    }
  }

  Future<void> initAudioPlayer() async {
    try {
      // Dans une application réelle, utiliser l'URL provenant du modèle
      // Pour la démo, nous utilisons un audio de test
      final audioUrl = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

      await audioPlayer.setUrl(audioUrl);
      await audioPlayer.pause(); // Préparer sans jouer immédiatement

      // Mise à jour de la durée
      audioPlayer.durationStream.listen((duration) {
        if (duration != null) {
          totalDuration.value = duration.inSeconds;
        }
      });

      // Écouter la position actuelle
      audioPlayer.positionStream.listen((position) {
        currentPosition.value = position.inSeconds;
      });

      // Écouter l'état de lecture
      audioPlayer.playerStateStream.listen((state) {
        isPlaying.value = state.playing;
      });
    } catch (e) {
      print('Erreur lors de l\'initialisation du lecteur audio: $e');
    }
  }

  void togglePlayPause() {
    if (lesson.value.type.toLowerCase() == 'audio') {
      if (isPlaying.value) {
        audioPlayer.pause();
      } else {
        audioPlayer.play();
      }
    } else if (lesson.value.type.toLowerCase() == 'video') {
      if (videoController.value!.value.isPlaying) {
        videoController.value!.pause();
      } else {
        videoController.value!.play();
      }
    }
  }

  void audioSeek(int seconds) {
    if (lesson.value.type.toLowerCase() == 'audio') {
      final newPosition = Duration(seconds: currentPosition.value + seconds);
      audioPlayer.seek(newPosition);
    }
  }

  void loadAdjacentLessons() {
    // Dans une application réelle, ces données viendraient de l'API
    // Pour la démo, nous simulons des leçons adjacentes

    if (parentCourse.value != null && parentCourse.value!.chapters.isNotEmpty) {
      // Trouver le chapitre actuel et l'index de la leçon actuelle
      for (var chapter in parentCourse.value!.chapters) {
        final lessonIndex = chapter.lessons.indexWhere((l) => l.id == lesson.value.id);

        if (lessonIndex != -1) {
          // Leçon précédente dans le même chapitre
          if (lessonIndex > 0) {
            previousLesson.value = chapter.lessons[lessonIndex - 1];
          }

          // Leçon suivante dans le même chapitre
          if (lessonIndex < chapter.lessons.length - 1) {
            nextLesson.value = chapter.lessons[lessonIndex + 1];
          }

          break;
        }
      }
    } else {
      // Génération de données factices pour la démo
      if (lesson.value.id > 1) {
        previousLesson.value = Lesson(
          id: lesson.value.id - 1,
          title: 'Leçon précédente',
          type: 'video',
          duration: 300,
          content: 'Contenu de la leçon précédente',
          isCompleted: true,
        );
      }

      nextLesson.value = Lesson(
        id: lesson.value.id + 1,
        title: 'Leçon suivante',
        type: 'audio',
        duration: 420,
        content: 'Contenu de la leçon suivante',
        isCompleted: false,
      );
    }
  }

  void loadRelatedLessons() {
    // Dans une application réelle, ces données viendraient de l'API
    // Pour la démo, nous simulons des leçons connexes
    relatedLessons.value = [
      Lesson(
        id: 101,
        title: 'Leçon complémentaire 1',
        type: 'video',
        duration: 360,
        content: 'Contenu complémentaire',
        isCompleted: false,
      ),
      Lesson(
        id: 102,
        title: 'Leçon complémentaire 2',
        type: 'lecture',
        duration: 180,
        content: 'Lecture complémentaire',
        isCompleted: false,
      ),
      Lesson(
        id: 103,
        title: 'Exercice pratique',
        type: 'interactive',
        duration: 600,
        content: 'Exercice interactif',
        isCompleted: false,
      ),
    ];
  }

  void checkFavoriteStatus() {
    // Dans une application réelle, vérifier dans la base de données locale
    // Pour la démo, valeur aléatoire
    isFavorite.value = lesson.value.id % 2 == 0;
  }

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
    // Dans une application réelle, sauvegarder dans la base de données locale
  }

  void markAsCompleted() {
    // Mettre à jour l'état localement
    final updatedLesson = lesson.value;
    updatedLesson.isCompleted = !updatedLesson.isCompleted;
    lesson.value = updatedLesson;

    // Dans une application réelle, envoyer à l'API
    // Afficher un message de confirmation
    Get.snackbar(
      updatedLesson.isCompleted ? 'Leçon terminée' : 'Leçon à revoir',
      updatedLesson.isCompleted
          ? 'Félicitations! Vous avez terminé cette leçon.'
          : 'Nous avons marqué cette leçon comme à revoir.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: updatedLesson.isCompleted
          ? Colors.green.withOpacity(0.9)
          : Colors.orange.withOpacity(0.9),
      colorText: Colors.white,
      margin: EdgeInsets.all(16),
    );
  }

  void navigateToLesson(Lesson targetLesson) {
    // Naviguer vers la leçon ciblée
    Get.off(
          () => Get.toNamed('/course-player', arguments: {
        'lesson': targetLesson,
        'course': parentCourse.value,
      }),
    );
  }

  void navigateToPreviousLesson() {
    if (previousLesson.value != null) {
      navigateToLesson(previousLesson.value!);
    }
  }

  void navigateToNextLesson() {
    if (nextLesson.value != null) {
      navigateToLesson(nextLesson.value!);
    }
  }

  void downloadLesson() async {
    // Dans une application réelle, cette fonction téléchargerait la leçon
    // Pour la démo, nous simulons le téléchargement

    Get.dialog(
      AlertDialog(
        title: Text('Téléchargement'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LinearProgressIndicator(),
            SizedBox(height: 16),
            Text('Téléchargement de la leçon en cours...'),
          ],
        ),
      ),
      barrierDismissible: false,
    );

    // Simuler le téléchargement
    await Future.delayed(Duration(seconds: 2));

    Get.back(); // Fermer la boîte de dialogue

    Get.snackbar(
      'Téléchargement terminé',
      'La leçon a été téléchargée et est disponible hors ligne.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.9),
      colorText: Colors.white,
      margin: EdgeInsets.all(16),
    );
  }

  void shareLesson() {
    // Dans une application réelle, partager un lien vers la leçon
    Share.share(
      'Découvre cette leçon sur l\'application eCEP: ${lesson.value.title}',
    );
  }
}