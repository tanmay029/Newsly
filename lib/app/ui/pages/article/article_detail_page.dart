import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:newsly/app/controllers/article_controller.dart';
import 'package:newsly/app/controllers/bookmark_controller.dart';
import 'package:newsly/app/data/models/article_model.dart';

// import '../../controllers/article_controller.dart';
// import '../../controllers/bookmark_controller.dart';
// import '../../data/models/article_model.dart';

class ArticleDetailPage extends StatelessWidget {
  final Article article = Get.arguments as Article;

  @override
  Widget build(BuildContext context) {
    Get.put(ArticleController());
    final bookmarkController = Get.find<BookmarkController>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(bookmarkController),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildAppBar(BookmarkController bookmarkController) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: article.urlToImage ?? '',
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[300],
                child: Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[300],
                child: Icon(Icons.image_not_supported, size: 50),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        GetBuilder<BookmarkController>(
          builder: (controller) => IconButton(
            icon: Icon(
              controller.isBookmarked(article)
                  ? Icons.bookmark
                  : Icons.bookmark_border,
              color: Colors.white,
            ),
            onPressed: () => controller.toggleBookmark(article),
          ),
        ),
        IconButton(
          icon: Icon(Icons.share, color: Colors.white),
          onPressed: () => Get.find<ArticleController>().shareArticle(),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 16),
            _buildArticleBody(),
            SizedBox(height: 24),
            _buildReadMoreButton(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                article.category,
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Spacer(),
            Text(
              DateFormat('MMM dd, yyyy').format(article.publishedAt),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Text(
          article.title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            height: 1.3,
          ),
        ),
        SizedBox(height: 8),
        Column(
          children: [
            Row(
              children: [
                Icon(Icons.account_circle, size: 16, color: Colors.grey[600]),
                SizedBox(width: 4),
                Text(
                  'By ${article.author ?? 'Unknown'}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            SizedBox(width: 16),
            Row(
              children: [
                Icon(Icons.source, size: 16, color: Colors.grey[600]),
                SizedBox(width: 4),
                Text(
                  article.source,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildArticleBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          article.description,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
            height: 1.5,
          ),
        ),
        if (article.content != null) ...[
          SizedBox(height: 16),
          Text(
            article.content!,
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildReadMoreButton() {
    if (article.url == null) return SizedBox.shrink();

    return Container(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => Get.find<ArticleController>().openArticleUrl(),
        icon: Icon(Icons.open_in_new),
        label: Text('Read Full Article'),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
