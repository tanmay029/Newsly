import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/article_model.dart';
import '../../utils/constants.dart';

class StorageService extends GetxService {
  late GetStorage _box; // This line should be present

  @override
  void onInit() {
    super.onInit();
    _box = GetStorage(); // This initializes _box
  }

  // Theme methods
  bool get isDarkMode => _box.read(Constants.keyTheme) ?? false;
  
  void saveThemeMode(bool isDarkMode) {
    _box.write(Constants.keyTheme, isDarkMode);
  }

  // Bookmark methods with robust error handling
  List<Article> getBookmarks() {
    try {
      // Get raw data from storage
      final dynamic rawData = _box.read(Constants.keyBookmarks);
      
      // If no data exists, return empty list
      if (rawData == null) {
        print('No bookmark data found');
        return [];
      }
      
      // Ensure it's a List
      if (rawData is! List) {
        print('Invalid bookmark data format: ${rawData.runtimeType}');
        // Clear corrupted data
        _box.remove(Constants.keyBookmarks);
        return [];
      }
      
      // Parse each bookmark safely
      List<Article> articles = [];
      for (int i = 0; i < rawData.length; i++) {
        try {
          final item = rawData[i];
          if (item is Map<String, dynamic>) {
            final article = Article.fromJson(item);
            articles.add(article);
          } else if (item is Map) {
            // Convert Map to Map<String, dynamic>
            final convertedMap = Map<String, dynamic>.from(item);
            final article = Article.fromJson(convertedMap);
            articles.add(article);
          } else {
            print('Skipping invalid bookmark item at index $i: ${item.runtimeType}');
          }
        } catch (e) {
          print('Error parsing bookmark at index $i: $e');
          // Continue with next item instead of failing completely
        }
      }
      
      print('Successfully loaded ${articles.length} bookmarks');
      return articles;
      
    } catch (e) {
      print('Critical error loading bookmarks: $e');
      // Clear potentially corrupted data
      _box.remove(Constants.keyBookmarks);
      return [];
    }
  }

  void saveBookmarks(List<Article> bookmarks) {
    try {
      // Convert to JSON with extra safety
      List<Map<String, dynamic>> jsonList = [];
      
      for (Article article in bookmarks) {
        try {
          jsonList.add(article.toJson());
        } catch (e) {
          print('Error converting article to JSON: ${article.title}, error: $e');
          // Skip this article but continue with others
        }
      }
      
      _box.write(Constants.keyBookmarks, jsonList);
      print('Successfully saved ${jsonList.length} bookmarks');
      
    } catch (e) {
      print('Error saving bookmarks: $e');
      throw Exception('Failed to save bookmarks: $e');
    }
  }

  bool isBookmarked(Article article) {
    try {
      List<Article> bookmarks = getBookmarks();
      
      // Use title and source for comparison to avoid object reference issues
      return bookmarks.any((bookmark) => 
          bookmark.title == article.title && 
          bookmark.source == article.source);
          
    } catch (e) {
      print('Error checking bookmark status: $e');
      return false;
    }
  }

  void addBookmark(Article article) {
    try {
      List<Article> bookmarks = getBookmarks();
      
      // Check if already exists
      bool exists = bookmarks.any((bookmark) => 
          bookmark.title == article.title && 
          bookmark.source == article.source);
          
      if (!exists) {
        bookmarks.add(article);
        saveBookmarks(bookmarks);
        print('Bookmark added successfully: ${article.title}');
      } else {
        print('Article already bookmarked: ${article.title}');
      }
      
    } catch (e) {
      print('Error adding bookmark: $e');
      throw Exception('Failed to add bookmark: $e');
    }
  }

  void removeBookmark(Article article) {
    try {
      List<Article> bookmarks = getBookmarks();
      
      bookmarks.removeWhere((bookmark) => 
          bookmark.title == article.title && 
          bookmark.source == article.source);
          
      saveBookmarks(bookmarks);
      print('Bookmark removed successfully: ${article.title}');
      
    } catch (e) {
      print('Error removing bookmark: $e');
      throw Exception('Failed to remove bookmark: $e');
    }
  }

  // Add this method to clear corrupted data
  void clearBookmarks() {
    try {
      _box.remove(Constants.keyBookmarks);
      print('All bookmarks cleared');
    } catch (e) {
      print('Error clearing bookmarks: $e');
    }
  }

  // User data methods
  void saveUserData(Map<String, dynamic> userData) {
    _box.write(Constants.keyUser, userData);
  }

  Map<String, dynamic>? getUserData() {
    return _box.read<Map<String, dynamic>>(Constants.keyUser);
  }

  void clearUserData() {
    _box.remove(Constants.keyUser);
  }
}
