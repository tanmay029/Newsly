import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsly/app/controllers/auth_controller.dart';
import 'package:newsly/app/controllers/bookmark_controller.dart';
import 'package:newsly/app/controllers/theme_controller.dart';

// import '../../controllers/auth_controller.dart';
// import '../../controllers/theme_controller.dart';
// import '../../controllers/bookmark_controller.dart';

class ProfilePage extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    Get.put(BookmarkController());
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            SizedBox(height: 20),
            _buildMenuSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade600, Colors.blue.shade800],
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 50,
              color: Colors.blue.shade600,
            ),
          ),
          SizedBox(height: 16),
          Obx(() => Text(
            authController.user?.displayName ?? 'User',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          )),
          SizedBox(height: 4),
          Obx(() => Text(
            authController.user?.email ?? '',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildMenuSection() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _buildStatsCard(),
          SizedBox(height: 20),
          _buildMenuItems(),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    return GetBuilder<BookmarkController>(
      builder: (bookmarkController) => Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                'Bookmarks',
                bookmarkController.bookmarks.length.toString(),
                Icons.bookmark,
              ),
              _buildStatItem(
                'Reading Time',
                '2.5h',
                Icons.access_time,
              ),
              _buildStatItem(
                'Articles Read',
                '45',
                Icons.article,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.blue),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItems() {
    return Column(
      children: [
        _buildMenuItem(
          'Dark Mode',
          'Switch between light and dark theme',
          Icons.dark_mode,
          trailing: Obx(() => Switch(
            value: themeController.isDarkMode,
            onChanged: (value) => themeController.toggleTheme(),
          )),
        ),
        _buildMenuItem(
          'Notifications',
          'Manage your notification preferences',
          Icons.notifications,
          onTap: () {
            Get.snackbar(
              'Coming Soon',
              'Notification settings will be available soon',
            );
          },
        ),
        _buildMenuItem(
          'Help & Support',
          'Get help or contact support',
          Icons.help,
          onTap: () {
            Get.snackbar(
              'Help',
              'Help section will be available soon',
            );
          },
        ),
        _buildMenuItem(
          'About',
          'App version and information',
          Icons.info,
          onTap: () => _showAboutDialog(),
        ),
        SizedBox(height: 20),
        _buildLogoutButton(),
      ],
    );
  }

  Widget _buildMenuItem(
    String title,
    String subtitle,
    IconData icon, {
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.blue),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: trailing ?? Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _showLogoutDialog,
        icon: Icon(Icons.logout, color: Colors.white),
        label: Text('Logout', style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              authController.logout();
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('About Newsly'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version: 1.0.0'),
            SizedBox(height: 8),
            Text('A modern news reading app built with Flutter'),
            SizedBox(height: 8),
            Text('© 2025 Newsly. All rights reserved.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
