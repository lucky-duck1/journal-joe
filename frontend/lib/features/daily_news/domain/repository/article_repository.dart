import 'dart:io';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart'; // CORRECT PATH

abstract class ArticleRepository {
  // API methods
  Future<DataState<List<ArticleEntity>>> getNewsArticles();

  // Database methods
  Future<List<ArticleEntity>> getSavedArticles();

  Future<void> saveArticle(ArticleEntity article, {File? mediaFile});

  Future<void> removeArticle(ArticleEntity article);

  Future<void> submitArticle(ArticleEntity article, {File? mediaFile});
}
