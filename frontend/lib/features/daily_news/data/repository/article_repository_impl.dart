import 'dart:io';
import 'package:dio/dio.dart';
import 'package:news_app_clean_architecture/core/constants/constants.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/remote/firebase_article_data_source.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/remote/media_service.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/remote/news_api_service.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/models/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final NewsApiService _newsApiService;
  final FirebaseArticleDataSource _firebaseDataSource;
  final MediaService _mediaService;

  ArticleRepositoryImpl(
    this._newsApiService,
    this._firebaseDataSource,
    this._mediaService,
  );

  @override
  Future<DataState<List<ArticleModel>>> getNewsArticles() async {
    try {
      final httpResponse = await _newsApiService.getNewsArticles(
        apiKey: newsAPIKey,
        country: countryQuery,
        category: categoryQuery,
      );

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data);
      } else {
        return DataFailed(
          DioError(
            error: httpResponse.response.statusMessage,
            response: httpResponse.response,
            type: DioErrorType.response,
            requestOptions: httpResponse.response.requestOptions,
          ),
        );
      }
    } on DioError catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<List<ArticleModel>> getSavedArticles() async {
    return _firebaseDataSource.getSavedArticles();
  }

  @override
  Future<void> removeArticle(ArticleEntity article) async {
    return _firebaseDataSource.removeArticle(article.id.toString());
  }

  @override
  Future<void> saveArticle(ArticleEntity article, {File? mediaFile}) async {
    String? mediaUrl;

    if (mediaFile != null) {
      mediaUrl = await _mediaService.uploadArticleMedia(
        mediaFile,
        '${article.id}.jpg',
      );
    }

    final updatedArticle =
        mediaUrl != null ? article.copyWith(urlToImage: mediaUrl) : article;

    await _firebaseDataSource
        .saveArticle(ArticleModel.fromEntity(updatedArticle));
  }

  @override
  Future<void> submitArticle(ArticleEntity article, {File? mediaFile}) async {
    try {
      await saveArticle(article, mediaFile: mediaFile);
      print("Article submitted successfully: ${article.title}");
    } catch (e) {
      throw Exception("Failed to submit article: $e");
    }
  }
}
