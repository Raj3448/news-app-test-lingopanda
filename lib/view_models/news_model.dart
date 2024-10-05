import 'package:freezed_annotation/freezed_annotation.dart';

part 'news_model.freezed.dart';
part 'news_model.g.dart';

@JsonSerializable(explicitToJson: true)
@freezed
class Article with _$Article {
  const factory Article({
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