class NewsArticle {
  final String title;
  final String description;

  NewsArticle({required this.title, required this.description});
}

// Mock Data for News Articles
List<NewsArticle> mockArticles = [
  NewsArticle(
    title: 'Breaking News: Flutter 3.0 Released!',
    description: 'Flutter has just released its latest version with exciting new features.',
  ),
  NewsArticle(
    title: 'New Study on Dart Performance',
    description: 'A recent study shows that Dart programming language performance has improved significantly.',
  ),
  NewsArticle(
    title: 'How to Build Beautiful UIs with Flutter',
    description: 'Learn the best practices for creating stunning user interfaces with Flutter.',
  ),
  // Add more articles as needed
];