import '../models/article_model.dart';

class DummyDataService {
  static List<Article> getFeaturedArticles() {
    return [
      Article(
        title: "Flutter 3.0 Revolution: What's New for Developers",
        description: "Explore the groundbreaking features and improvements in Flutter 3.0 that are changing mobile app development forever.",
        content: "Flutter 3.0 brings revolutionary changes to mobile app development with enhanced performance, new widgets, and improved developer experience...",
        urlToImage: "https://picsum.photos/400/250?random=1",
        url: "https://flutter.dev",
        source: "Flutter News",
        author: "John Doe",
        publishedAt: DateTime.now().subtract(Duration(hours: 2)),
        category: "Technology",
      ),
      Article(
        title: "AI-Powered Mobile Apps: The Future is Here",
        description: "Discover how artificial intelligence is transforming mobile applications and creating smarter user experiences.",
        content: "Artificial Intelligence is no longer a futuristic concept but a present reality shaping mobile applications...",
        urlToImage: "https://picsum.photos/400/250?random=2",
        url: "https://example.com",
        source: "Tech Today",
        author: "Jane Smith",
        publishedAt: DateTime.now().subtract(Duration(hours: 5)),
        category: "Technology",
      ),
      Article(
        title: "Sustainable Tech: Green Innovation in 2025",
        description: "Learn about the latest eco-friendly technologies making a positive impact on our planet.",
        content: "Green technology initiatives are leading the charge toward a more sustainable future...",
        urlToImage: "https://picsum.photos/400/250?random=3",
        url: "https://example.com",
        source: "Green Tech",
        author: "Mike Johnson",
        publishedAt: DateTime.now().subtract(Duration(hours: 8)),
        category: "Environment",
      ),
    ];
  }

  static List<String> getCategories() {
    return [
      'Technology',
      'Business',
      'Sports',
      'Health',
      'Entertainment',
      'Science',
      'Environment',
    ];
  }
}
