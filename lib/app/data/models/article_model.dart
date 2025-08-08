class Article {
  final String? id;
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
    this.id,
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
    return Article(
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      content: json['content']?.toString(),
      urlToImage: json['urlToImage']?.toString(),
      url: json['url']?.toString(),
      source: json['source']?['name']?.toString() ?? 
              json['source']?.toString() ?? 'Unknown',
      author: json['author']?.toString(),
      publishedAt: _parseDate(json['publishedAt']?.toString()),
      category: json['category']?.toString() ?? 'General',
    );
  }

  static DateTime _parseDate(String? dateString) {
    if (dateString == null) return DateTime.now();
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return DateTime.now();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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

  Article copyWith({String? id}) {
    return Article(
      id: id ?? this.id,
      title: title,
      description: description,
      content: content,
      urlToImage: urlToImage,
      url: url,
      source: source,
      author: author,
      publishedAt: publishedAt,
      category: category,
    );
  }
}
