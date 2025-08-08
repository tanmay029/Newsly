import 'package:get/get.dart';

import '../controllers/theme_controller.dart';
import '../controllers/auth_controller.dart';
import '../data/services/api_service.dart';
import '../data/services/storage_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.put(StorageService(), permanent: true);
    Get.put(ApiService(), permanent: true);
    
    // Controllers
    Get.put(ThemeController(), permanent: true);
    Get.put(AuthController(), permanent: true);
  }
}
