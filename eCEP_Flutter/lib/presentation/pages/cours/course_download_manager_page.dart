import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:client/app/extension/color.dart';
import 'package:client/presentation/controllers/courses/download_manager_controller.dart';
import 'package:client/presentation/widgets/app_bar_widget.dart';

class CourseDownloadManagerPage extends StatelessWidget {
  final DownloadManagerController controller = Get.put(DownloadManagerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: "Téléchargements",
        showBackButton: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: AppColors.textDark),
            onPressed: () => _showSearchDialog(context),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: AppColors.textDark),
            onSelected: (value) {
              switch (value) {
                case 'clear_all':
                  _showClearAllDialog(context);
                  break;
                case 'settings':
                  _showDownloadSettings(context);
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'clear_all',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: AppColors.error),
                    SizedBox(width: 8),
                    Text('Supprimer tout'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined, color: AppColors.textDark),
                    SizedBox(width: 8),
                    Text('Paramètres'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.downloadedCourses.isEmpty && controller.activeDownloads.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: () => controller.refreshDownloads(),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStorageInfo(),
                SizedBox(height: 24),
                if (controller.activeDownloads.isNotEmpty) ...[
                  _buildActiveDownloadsSection(),
                  SizedBox(height: 24),
                ],
                if (controller.downloadedCourses.isNotEmpty)
                  _buildDownloadedCoursesSection(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.download_done_outlined,
            size: 72,
            color: AppColors.textLight,
          ),
          SizedBox(height: 16),
          Text(
            'Pas de téléchargements',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Téléchargez des cours pour les consulter hors ligne',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textMedium,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Get.toNamed('/courses'),
            icon: Icon(Icons.add),
            label: Text('Parcourir les cours'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStorageInfo() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Stockage',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: 12),
            Obx(() => LinearProgressIndicator(
              value: controller.usedStoragePercentage.value,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                  controller.usedStoragePercentage.value > 0.9
                      ? AppColors.error
                      : AppColors.primary
              ),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            )),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Utilisé: ${controller.usedStorage.value}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMedium,
                  ),
                ),
                Text(
                  'Disponible: ${controller.availableStorage.value}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMedium,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveDownloadsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Téléchargements en cours',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        SizedBox(height: 8),
        ...controller.activeDownloads.map((download) => _buildActiveDownloadItem(download)),
      ],
    );
  }

  Widget _buildActiveDownloadItem(Map<String, dynamic> download) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: download['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    download['icon'],
                    color: download['color'],
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        download['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        download['subject'],
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    download['isPaused'] ? Icons.play_arrow : Icons.pause,
                    color: AppColors.primary,
                  ),
                  onPressed: () => controller.togglePauseDownload(download['id']),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: AppColors.error,
                  ),
                  onPressed: () => _showCancelDownloadDialog(download),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: download['progress'] / 100,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    minHeight: 4,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  '${download['progress']}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${download['downloadedSize']} / ${download['totalSize']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMedium,
                  ),
                ),
                Text(
                  download['remainingTime'],
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMedium,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadedCoursesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Téléchargements terminés',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        SizedBox(height: 12),
        ...controller.downloadedCourses.map((course) => _buildDownloadedCourseItem(course)),
      ],
    );
  }

  Widget _buildDownloadedCourseItem(Map<String, dynamic> course) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => controller.openDownloadedCourse(course['id']),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: course['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  course['icon'],
                  color: course['color'],
                  size: 30,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      course['subject'],
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMedium,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        _buildCourseContentInfo(Icons.video_library_outlined, course['videos']),
                        SizedBox(width: 16),
                        _buildCourseContentInfo(Icons.headphones_outlined, course['audios']),
                        SizedBox(width: 16),
                        _buildCourseContentInfo(Icons.description_outlined, course['documents']),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    course['size'],
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textMedium,
                    ),
                  ),
                  SizedBox(height: 8),
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: AppColors.error,
                    ),
                    onPressed: () => _showDeleteDownloadDialog(course),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseContentInfo(IconData icon, String count) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: AppColors.textLight,
        ),
        SizedBox(width: 4),
        Text(
          count,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textMedium,
          ),
        ),
      ],
    );
  }

  void _showSearchDialog(BuildContext context) {
    final searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Rechercher des téléchargements'),
        content: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Nom du cours',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onChanged: (value) => controller.filterDownloads(value),
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.filterDownloads('');
              Navigator.pop(context);
            },
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.filterDownloads(searchController.text);
              Navigator.pop(context);
            },
            child: Text('Rechercher'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Supprimer tous les téléchargements'),
        content: Text('Êtes-vous sûr de vouloir supprimer tous les téléchargements ? Cette action ne peut pas être annulée.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.clearAllDownloads();
              Navigator.pop(context);
            },
            child: Text('Supprimer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDownloadDialog(Map<String, dynamic> download) {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: Text('Annuler le téléchargement'),
        content: Text('Êtes-vous sûr de vouloir annuler le téléchargement de "${download['title']}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Non'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.cancelDownload(download['id']);
              Navigator.pop(context);
            },
            child: Text('Oui'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDownloadDialog(Map<String, dynamic> course) {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: Text('Supprimer le téléchargement'),
        content: Text('Êtes-vous sûr de vouloir supprimer "${course['title']}" de vos téléchargements ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteDownload(course['id']);
              Navigator.pop(context);
            },
            child: Text('Supprimer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showDownloadSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Paramètres de téléchargement',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text('Télécharger uniquement en Wi-Fi'),
                subtitle: Text('Économisez vos données mobiles'),
                trailing: Obx(() => Switch(
                  value: controller.wifiOnly.value,
                  onChanged: (value) => controller.setWifiOnly(value),
                  activeColor: AppColors.primary,
                )),
              ),
              ListTile(
                title: Text('Télécharger automatiquement les nouveaux contenus'),
                subtitle: Text('Pour les cours suivis'),
                trailing: Obx(() => Switch(
                  value: controller.autoDownloadNewContent.value,
                  onChanged: (value) => controller.setAutoDownloadNewContent(value),
                  activeColor: AppColors.primary,
                )),
              ),
              ListTile(
                title: Text('Qualité vidéo'),
                subtitle: Text('Choisir la qualité des vidéos téléchargées'),
                trailing: Obx(() => DropdownButton<String>(
                  value: controller.videoQuality.value,
                  items: [
                    DropdownMenuItem(value: 'Basse', child: Text('Basse')),
                    DropdownMenuItem(value: 'Moyenne', child: Text('Moyenne')),
                    DropdownMenuItem(value: 'Haute', child: Text('Haute')),
                  ],
                  onChanged: (value) => controller.setVideoQuality(value!),
                  underline: Container(),
                )),
              ),
            ],
          ),
        );
      },
    );
  }
}