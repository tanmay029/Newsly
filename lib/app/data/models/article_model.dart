class Article {
  final String title;
  final String description;
  final String? content;
  final String? urlToImage;
  final String? url;
  final String source;
  final String? author;
  final DateTime publishedAt;
  final String category;

  Article({
    required this.title,
    required this.description,
    this.content,
    this.urlToImage,
    this.url,
    required this.source,
    this.author,
    required this.publishedAt,
    required this.category,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    try {
      return Article(
        title: _safeString(json['title']),
        description: _safeString(json['description']),
        content: _safeString(json['content']),
        urlToImage: _safeString(json['urlToImage']),
        url: _safeString(json['url']),
        source: _extractSource(json['source']),
        author: _safeString(json['author']),
        publishedAt: _parseDate(json['publishedAt']),
        category: _safeString(json['category']),
      );
    } catch (e) {
      print('Error creating Article from JSON: $e');
      print('JSON  $json');
      rethrow;
    }
  }

  static String _safeString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  static String _extractSource(dynamic sourceData) {
    if (sourceData == null) return 'Unknown';
    
    if (sourceData is String) return sourceData;
    
    if (sourceData is Map) {
      return sourceData['name']?.toString() ?? 'Unknown';
    }
    
    return sourceData.toString();
  }

  static DateTime _parseDate(dynamic dateValue) {
    if (dateValue == null) return DateTime.now();
    
    try {
      return DateTime.parse(dateValue.toString());
    } catch (e) {
      print('Error parsing date: $dateValue');
      return DateTime.now();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'content': content,
      'urlToImage': urlToImage,
      'url': url,
      'source': source,
      'author': author,
      'publishedAt': publishedAt.toIso8601String(),
      'category': category,
    };
  }
}
