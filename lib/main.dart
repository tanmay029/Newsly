import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/bindings/initial_binding.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/ui/themes/app_theme.dart';
import 'app/controllers/theme_controller.dart';
import 'app/data/services/storage_service.dart'; // Add this import
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  await GetStorage.init();
  
  // Initialize StorageService before running the app
  Get.put<StorageService>(StorageService(), permanent: true);
  
  runApp(NewslyApp());
}

void clearCorruptedBookmarkData() {
  try {
    final storageService = Get.find<StorageService>();
    storageService.clearBookmarks();
    print('Cleared potentially corrupted bookmark data');
  } catch (e) {
    print('Error during cleanup: $e');
  }
}

class NewslyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Now ThemeController can safely access StorageService
    final themeController = Get.put(ThemeController(), permanent: true);
    
    return Obx(() => GetMaterialApp(
      title: 'Newsly',
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.SPLASH,
      getPages: AppPages.routes,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeController.themeMode,
      debugShowCheckedModeBanner: false,
    ));
  }
}
