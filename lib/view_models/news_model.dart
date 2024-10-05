import 'package:freezed_annotation/freezed_annotation.dart';

part 'news_model.freezed.dart';
part 'news_model.g.dart';

@freezed
class Article with _$Article {
  const factory Article({
    required Source source,
    String? author,
    String? title,
    String? description,
    String? url,
    String? urlToImage,
    required DateTime publishedAt,
    String? content,
  }) = _Article;

  factory Article.fromJson(Map<String, dynamic> json) => _$ArticleFromJson(json);
}

@freezed
class Source with _$Source {
  const factory Source({
    String? id,
    String? name,
  }) = _Source;

  factory Source.fromJson(Map<String, dynamic> json) => _$SourceFromJson(json);
}
