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
    _bookmarks.value = _storageService.getBookmarks();
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
    _storageService.addBookmark(article);
    loadBookmarks();
    Get.snackbar(
      'Bookmarked',
      'Article saved to bookmarks',
      duration: Duration(seconds: 2),
    );
  }

  void removeBookmark(Article article) {
    _storageService.removeBookmark(article);
    loadBookmarks();
    Get.snackbar(
      'Removed',
      'Article removed from bookmarks',
      duration: Duration(seconds: 2),
    );
  }

  bool isBookmarked(Article article) {
    return _storageService.isBookmarked(article);
  }

  void clearAllBookmarks() {
    _storageService.saveBookmarks([]);
    loadBookmarks();
    Get.snackbar(
      'Cleared',
      'All bookmarks removed',
      duration: Duration(seconds: 2),
    );
  }
}
