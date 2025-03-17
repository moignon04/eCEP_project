import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:client/app/extension/color.dart';
import 'package:client/data/models/badge.dart';
import 'package:client/presentation/widgets/app_bar_widget.dart';
import 'package:lottie/lottie.dart';

class BadgeDetailPage extends StatelessWidget {
  final ABadge badge = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: badge.name,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            _buildBadgeHeader(),
            SizedBox(height: 24),
            _buildBadgeDetails(),
            SizedBox(height: 24),
            if (!badge.isUnlocked) _buildProgressSection(),
            SizedBox(height: 24),
            _buildRelatedInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: badge.isUnlocked
                      ? AppColors.secondary.withOpacity(0.1)
                      : Colors.grey.shade200,
                ),
              ),
              Image.asset(
                badge.image,
                width: 100,
                height: 100,
                color: badge.isUnlocked ? null : Colors.grey.shade400,
              ),
              if (badge.isUnlocked)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            badge.name,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            badge.description,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textMedium,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: badge.isUnlocked
                  ? AppColors.success.withOpacity(0.1)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              badge.isUnlocked ? 'Badge débloqué' : 'À débloquer',
              style: TextStyle(
                color: badge.isUnlocked ? AppColors.success : Colors.grey.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeDetails() {
    // Informations simulées sur le badge
    final dateObtention = badge.isUnlocked ? '15/03/2024' : '--/--/----';
    final rarityLevel = _getBadgeRarity(badge.id);
    final badgeCategory = _getBadgeCategory(badge.id);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Détails du badge',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          SizedBox(height: 16),
          _buildDetailRow('Catégorie', badgeCategory),
          Divider(),
          _buildDetailRow('Rareté', rarityLevel),
          Divider(),
          _buildDetailRow('Date d\'obtention', dateObtention),
          Divider(),
          _buildDetailRow('Points gagnés', badge.isUnlocked ? '100 points' : '-'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.textMedium,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Votre progression',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: badge.progressPercentage,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 10,
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${badge.progress}/${badge.targetProgress}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Text(
                '${(badge.progressPercentage * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildNextSteps(),
        ],
      ),
    );
  }

  Widget _buildNextSteps() {
    // Étapes simulées pour obtenir le badge
    final List<Map<String, dynamic>> steps = [
      {
        'title': 'Terminer 3 cours de mathématiques',
        'isCompleted': badge.progress >= 2,
      },
      {
        'title': 'Obtenir au moins 80% à 5 exercices',
        'isCompleted': badge.progress >= 3,
      },
      {
        'title': 'Maintenir une série de 7 jours',
        'isCompleted': badge.progress >= badge.targetProgress,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Prochaines étapes',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        SizedBox(height: 8),
        ...steps.map((step) => _buildStepItem(step)),
      ],
    );
  }

  Widget _buildStepItem(Map<String, dynamic> step) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            step['isCompleted'] ? Icons.check_circle : Icons.radio_button_unchecked,
            color: step['isCompleted'] ? AppColors.success : Colors.grey.shade400,
            size: 18,
          ),
          SizedBox(width: 8),
          Text(
            step['title'],
            style: TextStyle(
              color: step['isCompleted'] ? AppColors.textDark : AppColors.textMedium,
              fontWeight: step['isCompleted'] ? FontWeight.bold : FontWeight.normal,
              decoration: step['isCompleted'] ? TextDecoration.lineThrough : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedInfo() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            badge.isUnlocked ? 'Félicitations !' : 'Comment obtenir ce badge',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          SizedBox(height: 16),
          if (badge.isUnlocked) ...[
            // Lottie animation for unlocked badge
            Center(
              child: Lottie.asset(
                'assets/animations/congratulations.json',
                width: 200,
                height: 200,
                repeat: true,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Vous avez débloqué ce badge ! Continuez à progresser pour en obtenir d\'autres.',
              style: TextStyle(
                color: AppColors.textMedium,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () => Get.back(),
                child: Text('Retour aux badges'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
          ] else ...[
            // Tips for locked badge
            _buildTipItem(
              icon: Icons.lightbulb_outline,
              title: 'Conseil',
              content: 'Connectez-vous régulièrement pour maintenir votre série.',
            ),
            SizedBox(height: 12),
            _buildTipItem(
              icon: Icons.school_outlined,
              title: 'Astuce',
              content: 'Complétez tous les exercices d\'un chapitre pour progresser plus rapidement.',
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => Get.toNamed('/courses'),
                icon: Icon(Icons.play_arrow),
                label: Text('Commencer à apprendre'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTipItem({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 18,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              SizedBox(height: 4),
              Text(
                content,
                style: TextStyle(
                  color: AppColors.textMedium,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getBadgeRarity(int badgeId) {
    // Simuler différents niveaux de rareté basés sur l'ID du badge
    switch (badgeId % 3) {
      case 0:
        return 'Commun';
      case 1:
        return 'Rare';
      case 2:
        return 'Épique';
      default:
        return 'Commun';
    }
  }

  String _getBadgeCategory(int badgeId) {
    // Simuler différentes catégories basées sur l'ID du badge
    switch (badgeId % 5) {
      case 0:
        return 'Assiduité';
      case 1:
        return 'Mathématiques';
      case 2:
        return 'Français';
      case 3:
        return 'Compétence';
      case 4:
        return 'Réussite';
      default:
        return 'Général';
    }
  }
}