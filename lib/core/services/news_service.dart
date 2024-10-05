import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:newshub/core/services/firebase_remote_config.dart';
import 'package:newshub/view_models/news_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:newshub/providers/country_code_provider.dart';

class NewsService {
  static final NewsService _instance = NewsService._internal();

  NewsService._internal();

  factory NewsService() {
    return _instance;
  }

  static const String _apiKey = '3cfdfafaadeb460588fcdcaadcdf6f68';
  static const String _baseUrl = 'https://newsapi.org';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<Either<Failure, List<Article>>> fetchTopHeadlines(
      BuildContext context) async {
    final countryCode =
        await FirebaseRemoteConfigService.fetchCountryCodeFromRemoteConfig();
    Provider.of<CountryCodeProvider>(context, listen: false)
        .updateCountryCode(countryCode);
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

  Future<Either<Failure, List<Article>>> fetchSavedArticles() async {
    try {
      final String uid = _auth.currentUser!.uid;
      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('saved_articles')
          .get();

      List<Article> savedArticles = snapshot.docs.map((doc) {
        return Article.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return Right(savedArticles);
    } catch (e) {
      return Left(Failure(error: 'Error fetching saved articles: $e'));
    }
  }

  Future<Either<Failure, List<Article>>> fetchFavArticles() async {
    try {
      final String uid = _auth.currentUser!.uid;
      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('fav_articles')
          .get();

      List<Article> favArticles = snapshot.docs.map((doc) {
        return Article.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return Right(favArticles);
    } catch (e) {
      return Left(Failure(error: 'Error fetching favorite articles: $e'));
    }
  }

  Future<Either<Failure, void>> addSavedArticle(Article article) async {
    try {
      final String uid = _auth.currentUser!.uid;
      final String articleId = article.publishedAt.toString();
      final data = article.toJson();
      print(data);
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('saved_articles')
          .doc(articleId)
          .set(data);

      return const Right(null);
    } catch (e) {
      return Left(Failure(error: 'Error adding saved article: $e'));
    }
  }

  Future<Either<Failure, void>> addFavArticle(Article article) async {
    try {
      final String uid = _auth.currentUser!.uid;
      final String articleId = article.publishedAt.toString();
      final data = article.toJson();

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('fav_articles')
          .doc(articleId)
          .set(data);

      return const Right(null);
    } catch (e) {
      return Left(Failure(error: 'Error adding favorite article: $e'));
    }
  }

  Future<bool> isSavedArticle(String articleId) async {
    try {
      final String uid = _auth.currentUser!.uid;

      final doc = await _firestore
          .collection('users')
          .doc(uid)
          .collection('saved_articles')
          .doc(articleId)
          .get();

      return doc.exists;
    } catch (e) {
      print('Error checking if saved article exists: $e');
      return false;
    }
  }

  Future<bool> isFavArticle(String articleId) async {
    try {
      final String uid = _auth.currentUser!.uid;

      final doc = await _firestore
          .collection('users')
          .doc(uid)
          .collection('fav_articles')
          .doc(articleId)
          .get();

      return doc.exists;
    } catch (e) {
      print('Error checking if favorite article exists: $e');
      return false;
    }
  }

  Future<Either<Failure, void>> removeSavedArticle(String articleId) async {
    try {
      final String uid = _auth.currentUser!.uid;

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('saved_articles')
          .doc(articleId)
          .delete();

      return const Right(null);
    } catch (e) {
      return Left(Failure(error: 'Error removing saved article: $e'));
    }
  }

  Future<Either<Failure, void>> removeFavArticle(String articleId) async {
    try {
      final String uid = _auth.currentUser!.uid;

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('fav_articles')
          .doc(articleId)
          .delete();

      return const Right(null);
    } catch (e) {
      return Left(Failure(error: 'Error removing favorite article: $e'));
    }
  }
}

class Failure {
  final String error;
  Failure({required this.error});
}
