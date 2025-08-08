import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/bookmark_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/theme_controller.dart';
import '../data/services/api_service.dart';
import '../data/services/storage_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize StorageService FIRST
    Get.put<StorageService>(StorageService(), permanent: true);
    
    // Wait for StorageService to be fully initialized
    Get.find<StorageService>(); // This ensures it's ready
    
    // Then initialize other services
    Get.put<ApiService>(ApiService(), permanent: true);
    
    // Initialize controllers that depend on StorageService
    Get.put<ThemeController>(ThemeController(), permanent: true);
    Get.put<AuthController>(AuthController(), permanent: true);
    
    // Lazy put controllers
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<BookmarkController>(() => BookmarkController());
  }
}
