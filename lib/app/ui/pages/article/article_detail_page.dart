import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart'; 
import 'package:newsly/app/controllers/article_controller.dart';
import 'package:newsly/app/controllers/bookmark_controller.dart';
import 'package:newsly/app/data/models/article_model.dart';

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
            _buildSummarySection(), 
            SizedBox(height: 16),
            _buildMetaInfo(),
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
                color: _getCategoryColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                article.category,
                style: TextStyle(
                  color: _getCategoryColor(),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Spacer(),
            Text(
              _formatTimeAgo(article.publishedAt),
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
        SizedBox(height: 12),
        Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue.shade100,
              child: Icon(
                Icons.person,
                color: Colors.blue.shade600,
                size: 16,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatAuthors(article.author),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _formatSources(article.source),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  
  Widget _buildSummarySection() {
    final summary = _generateSummary(article.description, article.content);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Get.isDarkMode 
            ? const Color(0xFF2C2C2C) 
            : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.blue.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.summarize,
                color: Colors.blue.shade600,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            summary,
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  // New meta info section
  Widget _buildMetaInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.isDarkMode 
            ? const Color(0xFF2C2C2C) 
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildMetaRow(
            Icons.schedule,
            'Published',
            _formatPublishedDate(article.publishedAt),
          ),
          const Divider(height: 24),
          _buildMetaRow(
            Icons.source,
            'Source',
            _formatSources(article.source),
          ),
          const Divider(height: 24),
          _buildMetaRow(
            Icons.category,
            'Category',
            article.category,
          ),
        ],
      ),
    );
  }

  Widget _buildMetaRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.blue.shade600,
        ),
        const SizedBox(width: 12),
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Get.isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReadMoreButton() {
    if (article.url == null) return SizedBox.shrink();

    return Container(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          print('Article URL: ${article.url}'); 
          _launchURL(article.url); 
        },
        icon: Icon(Icons.open_in_new),
        label: Text('Read Full Article'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    );
  }

  
  Future<void> _launchURL(String? url) async {
  print('Attempting to launch URL: $url');
  
  if (url == null || url.isEmpty) {
    print('URL is null or empty');
    Get.snackbar(
      'Error',
      'No URL available for this article',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    return;
  }

  try {
    
    String formattedUrl = url;
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      formattedUrl = 'https://$url';
    }
    
    final uri = Uri.parse(formattedUrl);
    print('Parsed URI: $uri');
    
    
    try {
      print('Attempting direct launch with externalApplication mode');
      bool launched = await launchUrl(
        uri, 
        mode: LaunchMode.externalApplication,
      );
      print('Launch result (external): $launched');
      
      if (!launched) {
        throw Exception('External launch failed');
      }
    } catch (e) {
      print('External launch failed: $e, trying platformDefault');
      
      
      bool launched = await launchUrl(
        uri,
        mode: LaunchMode.platformDefault,
      );
      print('Launch result (platform): $launched');
      
      if (!launched) {
        throw Exception('Platform default launch failed');
      }
    }
    
  } catch (e) {
    print('All launch attempts failed: $e');
    
    
    Get.defaultDialog(
      title: 'Unable to Open Article',
      middleText: 'Could not open the article automatically. You can copy the URL below:',
      textConfirm: 'Copy URL',
      textCancel: 'Close',
      onConfirm: () {
        _copyUrlToClipboard(url);
        Get.back();
      },
      content: Container(
        padding: EdgeInsets.all(16),
        child: SelectableText(
          url,
          style: TextStyle(fontSize: 12, color: Colors.blue),
        ),
      ),
    );
  }
}

void _copyUrlToClipboard(String url) {
  Clipboard.setData(ClipboardData(text: url));
  Get.snackbar(
    'Copied',
    'URL copied to clipboard',
    backgroundColor: Colors.green,
    colorText: Colors.white,
  );
}


  String _generateSummary(String description, String? content) {
    if (description.isNotEmpty && !description.contains('[Removed]')) {
      List<String> sentences = description.split('. ');
      if (sentences.length > 3) {
        return sentences.take(3).join('. ') + '.';
      }
      if (description.length > 200) {
        return description.substring(0, 200) + '...';
      }
      return description;
    }
    
    if (content != null && content.isNotEmpty && !content.contains('[Removed]')) {
      List<String> sentences = content.split('. ');
      if (sentences.length > 2) {
        return sentences.take(2).join('. ') + '.';
      }
      if (content.length > 150) {
        return content.substring(0, 150) + '...';
      }
      return content;
    }
    
    return 'No summary available for this article.';
  }

  String _formatAuthors(String? author) {
    if (author == null || author.isEmpty) {
      return 'Unknown Author';
    }
    
    List<String> authors = author.split(RegExp(r',|&|\band\b')).map((a) => a.trim()).toList();
    authors = authors.where((a) => a.isNotEmpty).toList();
    
    if (authors.isEmpty) {
      return 'Unknown Author';
    } else if (authors.length == 1) {
      return authors.first;
    } else {
      return '${authors.first} +${authors.length - 1} others';
    }
  }

  String _formatSources(String source) {
    if (source.isEmpty) {
      return 'Unknown Source';
    }
    
    List<String> sources = source.split(RegExp(r',|&|\band\b')).map((s) => s.trim()).toList();
    sources = sources.where((s) => s.isNotEmpty).toList();
    
    if (sources.isEmpty) {
      return 'Unknown Source';
    } else if (sources.length == 1) {
      return sources.first;
    } else {
      return '${sources.first} +${sources.length - 1} sources';
    }
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  String _formatPublishedDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Color _getCategoryColor() {
    switch (article.category.toLowerCase()) {
      case 'technology':
        return Colors.blue;
      case 'business':
        return Colors.green;
      case 'sports':
        return Colors.orange;
      case 'health':
        return Colors.red;
      case 'entertainment':
        return Colors.purple;
      case 'science':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}
