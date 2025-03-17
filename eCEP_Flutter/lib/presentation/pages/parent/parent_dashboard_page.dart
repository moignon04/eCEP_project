import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:client/app/extension/color.dart';
import 'package:client/presentation/controllers/parent/parent_dashboard_controller.dart';
import 'package:client/presentation/widgets/app_bar_widget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:fl_chart/fl_chart.dart';

class ParentDashboardPage extends StatelessWidget {
  final ParentDashboardController controller = Get.put(ParentDashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Tableau de bord',
        showBackButton: false,
        actions: [
          Obx(() => Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications_none, color: AppColors.textDark),
                onPressed: () => controller.navigateToNotifications(),
              ),
              if (controller.unreadNotifications.value > 0)
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${controller.unreadNotifications.value}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          )),
          IconButton(
            icon: Icon(Icons.message_outlined, color: AppColors.textDark),
            onPressed: () => controller.navigateToMessaging(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () => controller.loadData(),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildParentHeader(),
                _buildChildSelector(),
                _buildChildOverview(),
                _buildRecentActivities(),
                _buildSubjectSummary(),
                _buildUpcomingExams(),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.contactTeacher(),
        backgroundColor: AppColors.primary,
        child: Icon(Icons.message, color: Colors.white),
        tooltip: 'Contacter l\'enseignant',
      ),
    );
  }

  Widget _buildParentHeader() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(controller.parent.value['avatar'] ?? ''),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bonjour, ${controller.parent.value['firstName'] ?? ''}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Bienvenue sur votre espace parent',
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
    );
  }

  Widget _buildChildSelector() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Suivre mon enfant',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < controller.children.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Obx(() => GestureDetector(
                      onTap: () => controller.loadChildData(i),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: controller.selectedChildIndex.value == i
                              ? AppColors.primary.withOpacity(0.1)
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: controller.selectedChildIndex.value == i
                                ? AppColors.primary
                                : Colors.grey[300]!,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: AssetImage(controller.children[i]['avatar']),
                            ),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${controller.children[i]['firstName']} ${controller.children[i]['lastName']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: controller.selectedChildIndex.value == i
                                        ? AppColors.primary
                                        : AppColors.textDark,
                                  ),
                                ),
                                Text(
                                  'Classe: ${controller.children[i]['grade']}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textMedium,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 8),
                            controller.selectedChildIndex.value == i
                                ? Icon(
                              Icons.check_circle,
                              color: AppColors.primary,
                              size: 20,
                            )
                                : SizedBox.shrink(),
                          ],
                        ),
                      ),
                    )),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildOverview() {
    if (controller.children.isEmpty) {
      return SizedBox.shrink();
    }

    final selectedChild = controller.children[controller.selectedChildIndex.value];
    final recentProgress = selectedChild['recentProgress'] as List<dynamic>;

    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Aperçu des progrès',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              TextButton(
                onPressed: () => controller.navigateToChildDetail(),
                child: Text(
                  'Voir en détail',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
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
                Row(
                  children: [
                    _buildStatCard(
                      title: 'Score moyen',
                      value: '${selectedChild['averageScore']}%',
                      icon: Icons.assessment,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 10),
                    _buildStatCard(
                      title: 'Niveau',
                      value: '${selectedChild['level']}',
                      icon: Icons.star,
                      color: AppColors.secondary,
                    ),
                    SizedBox(width: 10),
                    _buildStatCard(
                      title: 'Série',
                      value: '${selectedChild['streakDays']} j',
                      icon: Icons.local_fire_department,
                      color: Colors.orange,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'Progression récente',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  height: 100,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      minX: 0,
                      maxX: (recentProgress.length - 1).toDouble(),
                      minY: 0,
                      maxY: 100,
                      lineBarsData: [
                        LineChartBarData(
                          spots: recentProgress
                              .asMap()
                              .entries
                              .map((entry) => FlSpot(entry.key.toDouble(), entry.value.toDouble()))
                              .toList(),
                          isCurved: true,
                          color: AppColors.primary,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: AppColors.primary.withOpacity(0.1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
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
              title,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textMedium,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivities() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Activités récentes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: controller.recentActivities.isEmpty
                ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Aucune activité récente',
                  style: TextStyle(
                    color: AppColors.textMedium,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            )
                : ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: controller.recentActivities.length > 3
                  ? 3
                  : controller.recentActivities.length,
              separatorBuilder: (context, index) => Divider(height: 1),
              itemBuilder: (context, index) {
                final activity = controller.recentActivities[index];
                return ListTile(
                  leading: _getActivityIcon(activity['type']),
                  title: Text(
                    activity['title'],
                    style: TextStyle(fontSize: 14),
                  ),
                  subtitle: Text(
                    '${activity['date']} à ${activity['time']}',
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: activity.containsKey('score')
                      ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getScoreColor(activity['score']).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${activity['score']}%',
                      style: TextStyle(
                        color: _getScoreColor(activity['score']),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                      : null,
                );
              },
            ),
          ),
          if (controller.recentActivities.length > 3)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Center(
                child: TextButton(
                  onPressed: () => controller.navigateToChildDetail(),
                  child: Text('Voir toutes les activités'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSubjectSummary() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance par matière',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          SizedBox(height: 16),
          ...controller.subjectSummary.map((subject) {
            return Container(
              margin: EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        subject['subject'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: subject['color'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${subject['score']}%',
                          style: TextStyle(
                            color: subject['color'],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  LinearPercentIndicator(
                    percent: subject['progress'] / 100,
                    lineHeight: 10.0,
                    animation: true,
                    animationDuration: 1000,
                    backgroundColor: subject['color'].withOpacity(0.1),
                    progressColor: subject['color'],
                    barRadius: Radius.circular(5),
                    padding: EdgeInsets.zero,
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progression: ${subject['progress']}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMedium,
                        ),
                      ),
                      Text(
                        '${subject['exercises']} exercices terminés',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMedium,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildUpcomingExams() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Évaluations à venir',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: controller.upcomingExams.isEmpty
                ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Aucune évaluation prévue',
                  style: TextStyle(
                    color: AppColors.textMedium,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            )
                : ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: controller.upcomingExams.length,
              separatorBuilder: (context, index) => Divider(height: 1),
              itemBuilder: (context, index) {
                final exam = controller.upcomingExams[index];
                final child = controller.children.firstWhere(
                      (child) => child['id'] == exam['childId'],
                  orElse: () => {'firstName': 'Enfant'},
                );

                // Déterminer l'icône et la couleur en fonction du type d'examen
                IconData icon;
                Color color;

                switch (exam['subject']) {
                  case 'Mathématiques':
                    color = AppColors.mathColor;
                    break;
                  case 'Français':
                    color = AppColors.frenchColor;
                    break;
                  case 'Histoire-Géographie':
                    color = AppColors.historyColor;
                    break;
                  case 'Sciences':
                    color = AppColors.scienceColor;
                    break;
                  default:
                    color = AppColors.primary;
                }

                switch (exam['type']) {
                  case 'quiz':
                    icon = Icons.quiz;
                    break;
                  case 'exam':
                    icon = Icons.assignment;
                    break;
                  default:
                    icon = Icons.description;
                }

                return ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color),
                  ),
                  title: Text(exam['title']),
                  subtitle: Text('Pour ${child['firstName']} • ${exam['date']} à ${exam['time']}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getActivityIcon(String type) {
    IconData icon;
    Color color;

    switch (type) {
      case 'course':
        icon = Icons.menu_book;
        color = AppColors.primary;
        break;
      case 'exercise':
        icon = Icons.assignment_turned_in;
        color = AppColors.secondary;
        break;
      case 'badge':
        icon = Icons.emoji_events;
        color = Colors.amber;
        break;
      default:
        icon = Icons.star;
        color = AppColors.info;
    }

    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }
}