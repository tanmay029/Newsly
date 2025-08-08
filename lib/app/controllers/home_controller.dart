import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/models/article_model.dart';
import '../data/services/api_service.dart';
import '../utils/constants.dart';

class HomeController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final _isLoading = false.obs;
  final _featuredArticles = <Article>[].obs;
  final _liveArticles = <Article>[].obs;
  final _categories = <String>[].obs;
  final _selectedCategory = 'Technology'.obs;

  bool get isLoading => _isLoading.value;
  List<Article> get featuredArticles => _featuredArticles;
  List<Article> get liveArticles => _liveArticles;
  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory.value;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    await Future.wait([
      loadCategories(),
      loadFeaturedArticles(),
      loadLiveNews(),
    ]);
  }

  Future<void> loadCategories() async {
    _categories.value = [
      'Technology',
      'Business',
      'Sports',
      'Health',
      'Entertainment',
      'Science',
      'Environment',
    ];
  }

  Future<void> loadFeaturedArticles() async {
    try {
      _isLoading.value = true;
      
      final response = await _apiService.get(
        '/top-headlines',
        queryParameters: {
          'apiKey': Constants.newsApiKey,
          'country': 'us',
          'pageSize': 5,
        },
      );

      if (response.data['status'] == 'ok') {
        List<dynamic> articlesJson = response.data['articles'];
        _featuredArticles.value = articlesJson
            .map((json) => Article.fromJson(json))
            .where((article) => 
                article.title.isNotEmpty && 
                article.description.isNotEmpty &&
                !article.title.contains('[Removed]') &&
                article.urlToImage != null &&
                article.urlToImage!.isNotEmpty)
            .take(5)
            .toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load featured news: ${e.toString()}');
      print('Featured news error: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> loadLiveNews() async {
    try {
      _isLoading.value = true;
      
      final response = await _apiService.get(
        '/everything',
        queryParameters: {
          'apiKey': Constants.newsApiKey,
          'q': _selectedCategory.value.toLowerCase(),
          'sortBy': 'publishedAt',
          'pageSize': 20,
          'language': 'en',
        },
      );

      if (response.data['status'] == 'ok') {
        List<dynamic> articlesJson = response.data['articles'];
        _liveArticles.value = articlesJson
            .map((json) => Article.fromJson(json))
            .where((article) => 
                article.title.isNotEmpty && 
                article.description.isNotEmpty &&
                !article.title.contains('[Removed]') &&
                !article.description.contains('[Removed]'))
            .toList();
      }
    } catch (e) {
      Get.snackbar(
        'Error', 
        'Failed to load news. Please check your internet connection.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Live news error: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  void selectCategory(String category) {
    if (_selectedCategory.value != category) {
      _selectedCategory.value = category;
      loadLiveNews();
    }
  }

  Future<void> refreshNews() async {
    await Future.wait([
      loadFeaturedArticles(),
      loadLiveNews(),
    ]);
  }
}
