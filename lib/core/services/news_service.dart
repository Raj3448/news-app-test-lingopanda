import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:newshub/core/services/firebase_remote_config.dart';
import 'package:newshub/providers/country_code_provider.dart';
import 'package:newshub/view_models/news_model.dart';
import 'package:provider/provider.dart';

class NewsService {
  static const String _apiKey = '3cfdfafaadeb460588fcdcaadcdf6f68';
  static const String _baseUrl = 'https://newsapi.org';

  static Future<Either<Failure, List<Article>>> fetchTopHeadlines(BuildContext context) async {
    final countryCode = await FirebaseRemoteConfigService.fetchCountryCodeFromRemoteConfig();
    Provider.of<CountryCodeProvider>(context, listen: false).updateCountryCode(countryCode);
    final url = Uri.parse(
        '$_baseUrl/v2/top-headlines?country=$countryCode&category=business&apiKey=$_apiKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> articlesJson = data['articles'];

        List<Article> articles = articlesJson
            .map((articleJson) => Article.fromJson(articleJson))
            .toList();

        return Right(articles);
      } else {
        return Left(
            Failure(error: 'Failed to load news: ${response.reasonPhrase}'));
      }
    } catch (e) {
      return Left(Failure(error: 'Error fetching news: $e'));
    }
  }
}

class Failure {
  final String error;

  Failure({required this.error});
}
