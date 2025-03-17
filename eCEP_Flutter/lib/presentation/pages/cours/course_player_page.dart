import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:client/app/extension/color.dart';
import 'package:client/data/models/lesson.dart';
import 'package:client/presentation/controllers/courses/course_player_controller.dart';
import 'package:client/presentation/widgets/app_bar_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:just_audio/just_audio.dart';

class CoursePlayerPage extends StatelessWidget {
  final CoursePlayerController controller = Get.put(CoursePlayerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: controller.lesson.value.title,
        showBackButton: true,
        actions: [
          IconButton(
            icon: Obx(() => Icon(
              controller.isFavorite.value
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: controller.isFavorite.value
                  ? AppColors.error
                  : AppColors.textMedium,
            )),
            onPressed: () => controller.toggleFavorite(),
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: AppColors.textDark),
            onPressed: () => _showOptions(context),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            _buildContentPlayer(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitle(),
                    SizedBox(height: 20),
                    _buildDescription(),
                    SizedBox(height: 40),
                    if (controller.relatedLessons.isNotEmpty)
                      _buildRelatedLessons(),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildContentPlayer() {
    switch (controller.lesson.value.type.toLowerCase()) {
      case 'video':
        return _buildVideoPlayer();
      case 'audio':
        return _buildAudioPlayer();
      case 'lecture':
      case 'text':
        return SizedBox(); // Texte affiché dans la description
      case 'interactive':
        return _buildInteractiveContent();
      default:
        return SizedBox();
    }
  }

  Widget _buildVideoPlayer() {
    if (controller.chewieController.value == null) {
      return Container(
        height: 200,
        color: Colors.black,
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Chewie(
        controller: controller.chewieController.value!,
      ),
    );
  }

  Widget _buildAudioPlayer() {
    return Container(
      height: 120,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.replay_10),
                onPressed: () => controller.audioSeek(-10),
              ),
              IconButton(
                iconSize: 50,
                icon: Obx(() => Icon(
                  controller.isPlaying.value
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  color: AppColors.primary,
                )),
                onPressed: () => controller.togglePlayPause(),
              ),
              IconButton(
                icon: Icon(Icons.forward_10),
                onPressed: () => controller.audioSeek(10),
              ),
            ],
          ),
          SizedBox(height: 8),
          Obx(() => LinearProgressIndicator(
            value: controller.currentPosition.value / controller.totalDuration.value,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          )),
          SizedBox(height: 4),
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(controller.currentPosition.value),
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textMedium,
                ),
              ),
              Text(
                _formatDuration(controller.totalDuration.value),
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textMedium,
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildInteractiveContent() {
    // Placeholder pour le contenu interactif
    return Container(
      height: 200,
      color: AppColors.secondary.withOpacity(0.1),
      child: Center(
        child: Text(
          'Contenu interactif',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.secondary,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          controller.lesson.value.title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getTypeColor(controller.lesson.value.type).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                controller.lesson.value.type,
                style: TextStyle(
                  fontSize: 12,
                  color: _getTypeColor(controller.lesson.value.type),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(width: 10),
            Icon(
              Icons.access_time,
              size: 16,
              color: AppColors.textLight,
            ),
            SizedBox(width: 4),
            Text(
              _formatDuration(controller.lesson.value.duration),
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textMedium,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        SizedBox(height: 12),
        Text(
          controller.lesson.value.content,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textDark,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildRelatedLessons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Leçons connexes',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: controller.relatedLessons.length,
          itemBuilder: (context, index) {
            final lesson = controller.relatedLessons[index];
            return _buildRelatedLessonItem(lesson);
          },
        ),
      ],
    );
  }

  Widget _buildRelatedLessonItem(Lesson lesson) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getTypeColor(lesson.type).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            lesson.typeIcon,
            color: _getTypeColor(lesson.type),
            size: 20,
          ),
        ),
        title: Text(
          lesson.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        subtitle: Text(
          _formatDuration(lesson.duration),
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textLight,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.textLight,
        ),
        onTap: () => controller.navigateToLesson(lesson),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (controller.previousLesson.value != null)
            ElevatedButton.icon(
              onPressed: () => controller.navigateToPreviousLesson(),
              icon: Icon(Icons.arrow_back),
              label: Text('Précédent'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary),
                elevation: 0,
              ),
            )
          else
            SizedBox(width: 40),
          ElevatedButton.icon(
            onPressed: () => controller.markAsCompleted(),
            icon: Icon(controller.lesson.value.isCompleted ? Icons.check : Icons.check_box_outline_blank),
            label: Text(controller.lesson.value.isCompleted ? 'Terminé' : 'Marquer comme terminé'),
            style: ElevatedButton.styleFrom(
              backgroundColor: controller.lesson.value.isCompleted ? AppColors.success : AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
          ),
          if (controller.nextLesson.value != null)
            ElevatedButton.icon(
              onPressed: () => controller.navigateToNextLesson(),
              icon: Icon(Icons.arrow_forward),
              label: Text('Suivant'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            )
          else
            SizedBox(width: 40),
        ],
      ),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.download_outlined),
                title: Text('Télécharger'),
                onTap: () {
                  Navigator.pop(context);
                  controller.downloadLesson();
                },
              ),
              ListTile(
                leading: Icon(Icons.share_outlined),
                title: Text('Partager'),
                onTap: () {
                  Navigator.pop(context);
                  controller.shareLesson();
                },
              ),
              ListTile(
                leading: Icon(Icons.note_add_outlined),
                title: Text('Prendre des notes'),
                onTap: () {
                  Navigator.pop(context);
                  // Naviguer vers la page de prise de notes
                },
              ),
              ListTile(
                leading: Icon(Icons.help_outline),
                title: Text('Poser une question'),
                onTap: () {
                  Navigator.pop(context);
                  // Naviguer vers la page de forum ou chat
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDuration(int seconds) {
    final Duration duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${duration.inHours > 0 ? '${duration.inHours}:' : ''}$twoDigitMinutes:$twoDigitSeconds';
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'video':
        return Color(0xFF3D5CFF);
      case 'audio':
        return Color(0xFFFF5252);
      case 'lecture':
      case 'text':
        return Color(0xFF16C79A);
      case 'interactive':
        return Color(0xFFFF8A00);
      default:
        return AppColors.primary;
    }
  }
}