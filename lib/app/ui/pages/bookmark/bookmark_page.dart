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
        elevation: 0,
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        actions: [
          Obx(() => controller.bookmarks.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear_all),
                  onPressed: _showClearAllDialog,
                )
              : SizedBox.shrink()),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: Obx(() {
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
                  key: Key('bookmark_${article.title.hashCode}'), // Use article hash as key
                  direction: DismissDirection.endToStart,
                  background: _buildDismissBackground(),
                  confirmDismiss: (direction) => _showRemoveDialog(article),
                  child: EnhancedArticleCard(article: article), // Removed index parameter
                );
              },
            ),
          );
        }),
      ),
    );
  }

  // ... rest of the methods remain the same (EmptyState, DismissBackground, etc.)
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.bookmark_border,
              size: 60,
              color: Colors.blue.shade300,
            ),
          ),
          SizedBox(height: 24),
          Text(
            'No Bookmarks Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Save articles you want to read later by tapping the bookmark icon',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade500,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Get.back(),
            icon: Icon(Icons.explore),
            label: Text('Browse Articles'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade400, Colors.red.shade600],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.delete_outline,
            color: Colors.white,
            size: 28,
          ),
          SizedBox(height: 4),
          Text(
            'Remove',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showRemoveDialog(article) {
    return Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.bookmark_remove, color: Colors.red),
            SizedBox(width: 8),
            Text('Remove Bookmark'),
          ],
        ),
        content: Text(
          'Are you sure you want to remove this article from bookmarks?',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.removeBookmark(article);
              Get.back(result: true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_amber, color: Colors.orange),
            SizedBox(width: 8),
            Text('Clear All Bookmarks'),
          ],
        ),
        content: Text(
          'Are you sure you want to remove all bookmarks? This action cannot be undone.',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.clearAllBookmarks();
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
