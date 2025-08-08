import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsly/app/controllers/bookmark_controller.dart';

// import '../../controllers/bookmark_controller.dart';
import '../../widgets/article_card.dart';

class BookmarkPage extends GetView<BookmarkController> {
  @override
  Widget build(BuildContext context) {
    Get.put(BookmarkController());
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarks'),
        actions: [
          Obx(() => controller.bookmarks.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear_all),
                  onPressed: _showClearAllDialog,
                )
              : SizedBox.shrink()),
        ],
      ),
      body: Obx(() {
        if (controller.bookmarks.isEmpty) {
          return _buildEmptyState();
        }
        
        return RefreshIndicator(
          onRefresh: () async => controller.loadBookmarks(),
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: controller.bookmarks.length,
            itemBuilder: (context, index) {
              final article = controller.bookmarks[index];
              return Dismissible(
                key: Key(article.title + article.source),
                direction: DismissDirection.endToStart,
                background: _buildDismissBackground(),
                confirmDismiss: (direction) => _showRemoveDialog(article),
                child: ArticleCard(article: article),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No Bookmarks Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Save articles you want to read later',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Get.back(),
            child: Text('Browse Articles'),
          ),
        ],
      ),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      color: Colors.red,
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20),
      child: Icon(
        Icons.delete,
        color: Colors.white,
        size: 30,
      ),
    );
  }

  Future<bool?> _showRemoveDialog(article) {
    return Get.dialog<bool>(
      AlertDialog(
        title: Text('Remove Bookmark'),
        content: Text('Are you sure you want to remove this article from bookmarks?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.removeBookmark(article);
              Get.back(result: true);
            },
            child: Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Clear All Bookmarks'),
        content: Text('Are you sure you want to remove all bookmarks? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.clearAllBookmarks();
              Get.back();
            },
            child: Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
