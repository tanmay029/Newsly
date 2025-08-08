import 'package:get/get.dart';

import '../data/models/article_model.dart';
import '../data/services/storage_service.dart';

class BookmarkController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  final _bookmarks = <Article>[].obs;
  List<Article> get bookmarks => _bookmarks;

  @override
  void onInit() {
    super.onInit();
    loadBookmarks();
  }

  void loadBookmarks() {
    try {
      _bookmarks.value = _storageService.getBookmarks();
    } catch (e) {
      print('Error loading bookmarks: $e');
      _bookmarks.value = [];
    }
  }

  void toggleBookmark(Article article) {
    if (isBookmarked(article)) {
      removeBookmark(article);
    } else {
      addBookmark(article);
    }
    update(); // Update UI
  }

  void addBookmark(Article article) {
    try {
      _storageService.addBookmark(article);
      loadBookmarks();
      Get.snackbar(
        'Bookmarked',
        'Article saved to bookmarks',
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('Error adding bookmark: $e');
    }
  }

  void removeBookmark(Article article) {
    try {
      _storageService.removeBookmark(article);
      loadBookmarks();
      Get.snackbar(
        'Removed',
        'Article removed from bookmarks',
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('Error removing bookmark: $e');
    }
  }

  bool isBookmarked(Article article) {
    try {
      return _storageService.isBookmarked(article);
    } catch (e) {
      print('Error checking bookmark status: $e');
      return false;
    }
  }

  void clearAllBookmarks() {
    try {
      _storageService.saveBookmarks([]);
      loadBookmarks();
      Get.snackbar(
        'Cleared',
        'All bookmarks removed',
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('Error clearing bookmarks: $e');
    }
  }
}
