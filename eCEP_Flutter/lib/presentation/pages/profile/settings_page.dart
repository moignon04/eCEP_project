import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:client/app/extension/color.dart';
import 'package:client/presentation/controllers/profile/settings_controller.dart';
import 'package:client/presentation/controllers/profile/profile_controller.dart';
import 'package:client/presentation/widgets/app_bar_widget.dart';
import 'package:image_picker/image_picker.dart';

class SettingsPage extends StatelessWidget {
  final SettingsController controller = Get.put(SettingsController());
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: "Paramètres",
        showBackButton: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileSection(),
              SizedBox(height: 24),
              _buildAccountSection(),
              SizedBox(height: 24),
              _buildPreferencesSection(),
              SizedBox(height: 24),
              _buildNotificationsSection(),
              SizedBox(height: 24),
              _buildSecuritySection(),
              SizedBox(height: 24),
              _buildSupportSection(),
              SizedBox(height: 24),
              _buildLogoutButton(),
              SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profil',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        SizedBox(height: 16),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(profileController.user.value.avatar),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () => _showChangeAvatarOptions(),
                          child: Container(
                            height: 32,
                            width: 32,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                _buildEditableField(
                  label: 'Prénom',
                  value: profileController.user.value.firstName,
                  onEdit: () => _showEditDialog(
                    'Prénom',
                    profileController.user.value.firstName,
                        (value) => profileController.updateUserData({'firstName': value}),
                  ),
                ),
                Divider(),
                _buildEditableField(
                  label: 'Nom',
                  value: profileController.user.value.lastName,
                  onEdit: () => _showEditDialog(
                    'Nom',
                    profileController.user.value.lastName,
                        (value) => profileController.updateUserData({'lastName': value}),
                  ),
                ),
                Divider(),
                _buildEditableField(
                  label: 'Email',
                  value: profileController.user.value.email,
                  onEdit: () => _showEditDialog(
                    'Email',
                    profileController.user.value.email,
                        (value) => profileController.updateUserData({'email': value}),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Compte',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        SizedBox(height: 16),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              _buildSettingItem(
                title: 'Changer le mot de passe',
                icon: Icons.lock_outline,
                onTap: () => _showChangePasswordDialog(),
              ),
              Divider(height: 1),
              _buildSettingItem(
                title: 'Informations de paiement',
                icon: Icons.payment_outlined,
                onTap: () => Get.toNamed('/payment-info'),
              ),
              Divider(height: 1),
              _buildSettingItem(
                title: 'Abonnement',
                icon: Icons.card_membership_outlined,
                onTap: () => Get.toNamed('/subscription'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreferencesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Préférences',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        SizedBox(height: 16),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              _buildSwitchSettingItem(
                title: 'Mode sombre',
                icon: Icons.dark_mode_outlined,
                value: controller.darkMode.value,
                onChanged: (value) => controller.setDarkMode(value),
              ),
              Divider(height: 1),
              _buildSwitchSettingItem(
                title: 'Téléchargement automatique',
                icon: Icons.download_outlined,
                value: controller.autoDownload.value,
                onChanged: (value) => controller.setAutoDownload(value),
              ),
              Divider(height: 1),
              _buildSwitchSettingItem(
                title: 'Wi-Fi uniquement',
                icon: Icons.wifi_outlined,
                value: controller.wifiOnly.value,
                onChanged: (value) => controller.setWifiOnly(value),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notifications',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        SizedBox(height: 16),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              _buildSwitchSettingItem(
                title: 'Notifications push',
                icon: Icons.notifications_outlined,
                value: controller.pushNotifications.value,
                onChanged: (value) => controller.setPushNotifications(value),
              ),
              Divider(height: 1),
              _buildSwitchSettingItem(
                title: 'Rappels quotidiens',
                icon: Icons.alarm_outlined,
                value: controller.dailyReminders.value,
                onChanged: (value) => controller.setDailyReminders(value),
              ),
              Divider(height: 1),
              _buildSwitchSettingItem(
                title: 'Mise à jour des cours',
                icon: Icons.update_outlined,
                value: controller.courseUpdates.value,
                onChanged: (value) => controller.setCourseUpdates(value),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSecuritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sécurité et confidentialité',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        SizedBox(height: 16),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              _buildSettingItem(
                title: 'Confidentialité',
                icon: Icons.privacy_tip_outlined,
                onTap: () => _showPrivacyPolicy(),
              ),
              Divider(height: 1),
              _buildSettingItem(
                title: 'Conditions d\'utilisation',
                icon: Icons.description_outlined,
                onTap: () => _showTermsOfService(),
              ),
              Divider(height: 1),
              _buildSettingItem(
                title: 'Supprimer le compte',
                icon: Icons.delete_outline,
                onTap: () => _showDeleteAccountDialog(),
                isDestructive: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Support',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        SizedBox(height: 16),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              _buildSettingItem(
                title: 'Centre d\'aide',
                icon: Icons.help_outline,
                onTap: () => Get.toNamed('/help-center'),
              ),
              Divider(height: 1),
              _buildSettingItem(
                title: 'Signaler un problème',
                icon: Icons.bug_report_outlined,
                onTap: () => Get.toNamed('/report-issue'),
              ),
              Divider(height: 1),
              _buildSettingItem(
                title: 'Contactez-nous',
                icon: Icons.mail_outline,
                onTap: () => Get.toNamed('/contact'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () => profileController.logout(),
        icon: Icon(Icons.logout),
        label: Text('Se déconnecter'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField({
    required String label,
    required String value,
    required VoidCallback onEdit,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textMedium,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.edit,
              color: AppColors.primary,
            ),
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : AppColors.textDark,
          fontWeight: isDestructive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : AppColors.primary,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.textLight,
      ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchSettingItem({
    required String title,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      title: Text(title),
      leading: Icon(
        icon,
        color: AppColors.primary,
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }

  void _showEditDialog(
      String label,
      String initialValue,
      Function(String) onSubmit,
      ) {
    final TextEditingController textController = TextEditingController(text: initialValue);

    Get.dialog(
      AlertDialog(
        title: Text('Modifier $label'),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                onSubmit(textController.text);
                Get.back();
              }
            },
            child: Text('Enregistrer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showChangeAvatarOptions() {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_camera, color: AppColors.primary),
              title: Text('Prendre une photo'),
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.camera);
              },
            ),
            Divider(height: 0),
            ListTile(
              leading: Icon(Icons.photo_library, color: AppColors.primary),
              title: Text('Choisir depuis la galerie'),
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.gallery);
              },
            ),
            Divider(height: 0),
            ListTile(
              leading: Icon(Icons.cancel, color: Colors.red),
              title: Text('Annuler'),
              onTap: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog() {
    final TextEditingController currentPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text('Changer le mot de passe'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Mot de passe actuel',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Nouveau mot de passe',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirmer le mot de passe',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (currentPasswordController.text.isEmpty ||
                  newPasswordController.text.isEmpty ||
                  confirmPasswordController.text.isEmpty) {
                Get.snackbar(
                  'Erreur',
                  'Veuillez remplir tous les champs',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }

              if (newPasswordController.text != confirmPasswordController.text) {
                Get.snackbar(
                  'Erreur',
                  'Les mots de passe ne correspondent pas',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }

              // Dans une application réelle, vérifier et changer le mot de passe
              controller.changePassword(
                currentPasswordController.text,
                newPasswordController.text,
              );
              Get.back();
            },
            child: Text('Enregistrer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    Get.toNamed('/privacy-policy');
  }

  void _showTermsOfService() {
    Get.toNamed('/terms-of-service');
  }

  void _showDeleteAccountDialog() {
    final TextEditingController passwordController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text('Supprimer le compte'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cette action est irréversible. Toutes vos données seront définitivement supprimées.',
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 16),
            Text(
              'Veuillez saisir votre mot de passe pour confirmer :',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (passwordController.text.isEmpty) {
                Get.snackbar(
                  'Erreur',
                  'Veuillez saisir votre mot de passe',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }

              // Dans une application réelle, vérifier le mot de passe et supprimer le compte
              controller.deleteAccount(passwordController.text);
              Get.back();
            },
            child: Text('Supprimer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}