import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:client/app/extension/color.dart';
import 'package:client/presentation/controllers/profile/achievements_controller.dart';
import 'package:client/presentation/widgets/app_bar_widget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class AchievementsPage extends StatelessWidget {
  final AchievementsController controller = Get.put(AchievementsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: "Mes réalisations",
        showBackButton: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () => controller.loadAchievements(),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryCard(),
                  SizedBox(height: 24),
                  _buildTabs(),
                  SizedBox(height: 16),
                  _buildTabContent(),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.emoji_events,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vos réalisations',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Continuez à apprendre pour débloquer plus de réalisations',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            LinearPercentIndicator(
              lineHeight: 10.0,
              percent: controller.globalProgress.value,
              backgroundColor: Colors.grey.shade200,
              progressColor: AppColors.primary,
              animation: true,
              animationDuration: 1000,
              barRadius: Radius.circular(5),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(controller.globalProgress.value * 100).toInt()}% complété',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  '${controller.unlockedCount.value}/${controller.totalCount.value} réalisations',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textMedium,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  icon: Icons.trending_up,
                  value: '${controller.stats.value['level'] ?? 0}',
                  label: 'Niveau',
                  color: AppColors.primary,
                ),
                _buildStatItem(
                  icon: Icons.star,
                  value: '${controller.stats.value['points'] ?? 0}',
                  label: 'Points',
                  color: AppColors.secondary,
                ),
                _buildStatItem(
                  icon: Icons.local_fire_department,
                  value: '${controller.stats.value['streakDays'] ?? 0}',
                  label: 'Jours consécutifs',
                  color: Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 16,
          ),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildTabItem(0, 'Tous'),
          _buildTabItem(1, 'Débloqués'),
          _buildTabItem(2, 'En cours'),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String title) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.selectedTabIndex.value = index,
        child: Container(
          decoration: BoxDecoration(
            color: controller.selectedTabIndex.value == index
                ? AppColors.primary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: controller.selectedTabIndex.value == index
                    ? Colors.white
                    : AppColors.textMedium,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    List<Map<String, dynamic>> achievements = [];

    switch (controller.selectedTabIndex.value) {
      case 0: // Tous
        achievements = controller.allAchievements;
        break;
      case 1: // Débloqués
        achievements = controller.allAchievements
            .where((achievement) => achievement['isUnlocked'])
            .toList();
        break;
      case 2: // En cours
        achievements = controller.allAchievements
            .where((achievement) => !achievement['isUnlocked'])
            .toList();
        break;
    }

    if (achievements.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.only(top: 32),
          child: Column(
            children: [
              Icon(
                Icons.emoji_events_outlined,
                size: 64,
                color: Colors.grey.shade400,
              ),
              SizedBox(height: 16),
              Text(
                'Aucune réalisation trouvée',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Continuez à apprendre pour débloquer des réalisations',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textMedium,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return AnimationLimiter(
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: _buildAchievementCard(achievements[index]),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAchievementCard(Map<String, dynamic> achievement) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            _buildAchievementIcon(achievement),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    achievement['title'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    achievement['description'],
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textMedium,
                    ),
                  ),
                  SizedBox(height: 8),
                  if (!achievement['isUnlocked']) ...[
                    LinearPercentIndicator(
                      lineHeight: 8.0,
                      percent: achievement['progress'] / achievement['target'],
                      backgroundColor: Colors.grey.shade200,
                      progressColor: _getCategoryColor(achievement['category']),
                      barRadius: Radius.circular(4),
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${achievement['progress']}/${achievement['target']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textMedium,
                          ),
                        ),
                        Text(
                          '${((achievement['progress'] / achievement['target']) * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _getCategoryColor(achievement['category']),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: AppColors.textLight,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Débloqué le ${achievement['date']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 8),
            if (achievement['isUnlocked'])
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: AppColors.success,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementIcon(Map<String, dynamic> achievement) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getCategoryColor(achievement['category']).withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        _getCategoryIcon(achievement['category']),
        color: _getCategoryColor(achievement['category']),
        size: 24,
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'cours':
        return AppColors.primary;
      case 'exercice':
        return AppColors.secondary;
      case 'assiduité':
        return Colors.orange;
      case 'progression':
        return AppColors.success;
      case 'score':
        return Colors.purple;
      default:
        return AppColors.primary;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'cours':
        return Icons.menu_book;
      case 'exercice':
        return Icons.assignment;
      case 'assiduité':
        return Icons.local_fire_department;
      case 'progression':
        return Icons.trending_up;
      case 'score':
        return Icons.star;
      default:
        return Icons.emoji_events;
    }
  }
}