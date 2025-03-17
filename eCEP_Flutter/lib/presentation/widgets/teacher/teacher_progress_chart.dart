import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:client/app/extension/color.dart';

class SubjectProgressChart extends StatelessWidget {
  final Map<String, double> subjectScores;

  const SubjectProgressChart({
    Key? key,
    required this.subjectScores,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
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
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance par matière',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          SizedBox(height: 24),
          Expanded(
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: _generateSections(),
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {},
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: _generateLegends(),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _generateSections() {
    final List<PieChartSectionData> sections = [];

    int i = 0;
    subjectScores.forEach((subject, score) {
      sections.add(
        PieChartSectionData(
          color: _getSubjectColor(subject),
          value: score,
          title: '${score.toStringAsFixed(0)}%',
          radius: 100,
          titleStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
      i++;
    });

    return sections;
  }

  List<Widget> _generateLegends() {
    final List<Widget> legends = [];

    subjectScores.forEach((subject, score) {
      legends.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              color: _getSubjectColor(subject),
            ),
            SizedBox(width: 4),
            Text(
              subject,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      );
    });

    return legends;
  }

  Color _getSubjectColor(String subject) {
    switch (subject.toLowerCase()) {
      case 'mathématiques':
        return AppColors.mathColor;
      case 'français':
        return AppColors.frenchColor;
      case 'histoire-géographie':
        return AppColors.historyColor;
      case 'sciences':
        return AppColors.scienceColor;
      default:
        return Colors.grey;
    }
  }
}