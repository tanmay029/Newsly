import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/article_model.dart';

class StorageService extends GetxService {
  final _storage = GetStorage();

  // Theme
  bool get isDarkMode => _storage.read('isDarkMode') ?? false;
  void saveThemeMode(bool isDarkMode) => _storage.write('isDarkMode', isDarkMode);

  // Bookmarks
  List<Article> getBookmarks() {
    List<dynamic>? bookmarksJson = _storage.read('bookmarks');
    if (bookmarksJson == null) return [];
    
    return bookmarksJson
        .map((json) => Article.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  void saveBookmarks(List<Article> bookmarks) {
    List<Map<String, dynamic>> bookmarksJson = 
        bookmarks.map((article) => article.toJson()).toList();
    _storage.write('bookmarks', bookmarksJson);
  }

  void addBookmark(Article article) {
    List<Article> bookmarks = getBookmarks();
    String articleId = article.title + article.source;
    
    if (!bookmarks.any((b) => (b.title + b.source) == articleId)) {
      bookmarks.add(article.copyWith(id: articleId));
      saveBookmarks(bookmarks);
    }
  }

  void removeBookmark(Article article) {
    List<Article> bookmarks = getBookmarks();
    String articleId = article.title + article.source;
    bookmarks.removeWhere((b) => (b.title + b.source) == articleId);
    saveBookmarks(bookmarks);
  }

  bool isBookmarked(Article article) {
    List<Article> bookmarks = getBookmarks();
    String articleId = article.title + article.source;
    return bookmarks.any((b) => (b.title + b.source) == articleId);
  }

  // User data
  void saveUserData(String key, dynamic value) => _storage.write(key, value);
  T? getUserData<T>(String key) => _storage.read<T>(key);
  void clearUserData() => _storage.erase();
}
