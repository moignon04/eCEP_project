import 'package:get/get.dart';
import 'package:client/data/models/badge.dart';
import 'package:client/data/models/mock_data.dart';

class BadgesController extends GetxController {
  // États de l'interface
  final isLoading = true.obs;
  final progressPercentage = 0.0.obs;

  // Listes des badges
  final badges = <ABadge>[].obs;
  final unlockedBadges = <ABadge>[].obs;
  final lockedBadges = <ABadge>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadBadges();
  }

  Future<void> loadBadges() async {
    isLoading.value = true;

    try {
      // Simuler un délai réseau
      await Future.delayed(Duration(seconds: 1));

      // Charger les badges depuis les données simulées
      badges.value = MockData.badges.map((data) => ABadge.fromJson(data)).toList();

      // Séparer les badges débloqués et verrouillés
      unlockedBadges.value = badges.where((badge) => badge.isUnlocked).toList();
      lockedBadges.value = badges.where((badge) => !badge.isUnlocked).toList();

      // Calculer le pourcentage de progression
      progressPercentage.value = (unlockedBadges.length / badges.length) * 100;

    } catch (e) {
      print('Erreur lors du chargement des badges: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Dans une application réelle, cette fonction serait appelée lorsqu'un badge est débloqué
  void unlockBadge(int badgeId) async {
    final index = badges.indexWhere((badge) => badge.id == badgeId);
    if (index != -1) {
      // Mettre à jour le badge
      final ABadge updatedBadge = ABadge(
        id: badges[index].id,
        name: badges[index].name,
        description: badges[index].description,
        image: badges[index].image,
        isUnlocked: true,
        progress: badges[index].targetProgress,
        targetProgress: badges[index].targetProgress,
      );

      // Mettre à jour les listes
      badges[index] = updatedBadge;
      lockedBadges.removeWhere((badge) => badge.id == badgeId);
      unlockedBadges.add(updatedBadge);

      // Recalculer le pourcentage de progression
      progressPercentage.value = (unlockedBadges.length / badges.length) * 100;

      // Afficher la notification de déblocage de badge
      Get.toNamed('/badges', arguments: {
        'newBadge': true,
        'badge': updatedBadge,
      });
    }
  }

  // Dans une application réelle, cette fonction mettrait à jour la progression d'un badge
  void updateBadgeProgress(int badgeId, int progress) {
    final index = badges.indexWhere((badge) => badge.id == badgeId);
    if (index != -1 && !badges[index].isUnlocked) {
      // Créer une copie du badge avec la progression mise à jour
      final ABadge updatedBadge = ABadge(
        id: badges[index].id,
        name: badges[index].name,
        description: badges[index].description,
        image: badges[index].image,
        isUnlocked: badges[index].isUnlocked,
        progress: progress,
        targetProgress: badges[index].targetProgress,
      );

      // Si le badge est débloqué
      if (progress >= updatedBadge.targetProgress) {
        unlockBadge(badgeId);
      } else {
        // Sinon, mettre simplement à jour la progression
        badges[index] = updatedBadge;
        final lockIndex = lockedBadges.indexWhere((badge) => badge.id == badgeId);
        if (lockIndex != -1) {
          lockedBadges[lockIndex] = updatedBadge;
        }
      }
    }
  }
}