import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/services/storage_service.dart';

class ThemeController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  
  final _isDarkMode = false.obs;
  bool get isDarkMode => _isDarkMode.value;
  
  ThemeMode get themeMode => _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    _isDarkMode.value = _storageService.isDarkMode;
  }

  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    _storageService.saveThemeMode(_isDarkMode.value);
    Get.changeThemeMode(themeMode);
  }
}
