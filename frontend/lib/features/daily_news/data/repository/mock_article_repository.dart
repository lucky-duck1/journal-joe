import 'dart:io';
import 'package:dio/dio.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';

class MockArticleRepository implements ArticleRepository {
  final List<ArticleEntity> _savedArticles = [];
  final List<ArticleEntity> _submittedArticles = [];

  @override
  Future<DataState<List<ArticleEntity>>> getNewsArticles() async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      List<ArticleEntity> articles = [
            const ArticleEntity(
              id: 1,
              author: 'Author 1',
              title: 'Mock Article 1',
              description: 'Description of Mock Article 1',
              url:
                  'https://www.nytimes.com/es/interactive/2020/espanol/estados-unidos/donald-trump-elecciones.html',
              urlToImage:
                  'https://static01.nyt.com/newsgraphics/2019/08/01/candidate-pages/7d63f01f112e79da7ac60c0448a4047a155ff410/trump.jpg',
              publishedAt: '2023-01-01T00:00:00Z',
              content: 'Content of Mock Article 1',
            ),
          ] +
          _submittedArticles;
      return DataSuccess(articles);
    } catch (e) {
      return DataFailed(
        DioError(
          requestOptions: RequestOptions(path: ''),
          error: e.toString(),
        ),
      );
    }
  }

  @override
  Future<List<ArticleEntity>> getSavedArticles() async {
    await Future.delayed(const Duration(seconds: 1));
    return _savedArticles;
  }

  @override
  Future<void> saveArticle(ArticleEntity article, {File? mediaFile}) async {
    await Future.delayed(const Duration(seconds: 1));
    // Optionally, you can process mediaFile here if needed (for mock, we ignore it)
    _savedArticles.add(article);
  }

  @override
  Future<void> removeArticle(ArticleEntity article) async {
    await Future.delayed(const Duration(seconds: 1));
    _savedArticles.removeWhere((savedArticle) => savedArticle.id == article.id);
  }

  @override
  Future<void> submitArticle(ArticleEntity article, {File? mediaFile}) async {
    await Future.delayed(const Duration(seconds: 1));
    // Simulate assigning a new unique ID when submitting
    int newId = DateTime.now().millisecondsSinceEpoch;
    ArticleEntity newArticle = article.copyWith(id: newId);
    // Optionally, process mediaFile if needed (for mock, we ignore it)
    _submittedArticles.add(newArticle);
  }
}
