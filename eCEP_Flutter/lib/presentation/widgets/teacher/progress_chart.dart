import 'package:client/app/extension/color.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SubjectProgressChart extends StatelessWidget {
  final Map<String, double> subjectScores;

  const SubjectProgressChart({
    Key? key,
    required this.subjectScores,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance par matière',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        String subject = '';
                        switch (groupIndex) {
                          case 0:
                            subject = 'Mathématiques';
                            break;
                          case 1:
                            subject = 'Français';
                            break;
                          case 2:
                            subject = 'Histoire-Géo';
                            break;
                          case 3:
                            subject = 'Sciences';
                            break;
                        }
                        return BarTooltipItem(
                          '$subject\n${rod.toY.toInt()}%', // Utilisez rod.toY
                          const TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return Text(
                                'Math',
                                style: TextStyle(
                                  color: const Color(0xff7589a2),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              );
                            case 1:
                              return Text(
                                'Fr',
                                style: TextStyle(
                                  color: const Color(0xff7589a2),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              );
                            case 2:
                              return Text(
                                'HG',
                                style: TextStyle(
                                  color: const Color(0xff7589a2),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              );
                            case 3:
                              return Text(
                                'Sc',
                                style: TextStyle(
                                  color: const Color(0xff7589a2),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              );
                            default:
                              return Text('');
                          }
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: [
                    _makeBarGroup(0, subjectScores['Mathématiques'] ?? 0, AppColors.mathColor),
                    _makeBarGroup(1, subjectScores['Français'] ?? 0, AppColors.frenchColor),
                    _makeBarGroup(2, subjectScores['Histoire-Géographie'] ?? 0, AppColors.historyColor),
                    _makeBarGroup(3, subjectScores['Sciences'] ?? 0, AppColors.scienceColor),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Colors.blue,
          width: 22,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}