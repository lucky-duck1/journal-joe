import 'package:dio/dio.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';

class MockArticleRepository implements ArticleRepository {
  @override
  Future<DataState<List<ArticleEntity>>> getNewsArticles() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    try {
      // Return mock articles
      List<ArticleEntity> articles = [
        const ArticleEntity(
          id: 1,
          author: 'Author 1',
          title: 'Mock Article 1',
          description: 'Description of Mock Article 1',
          url: 'https://www.nytimes.com/es/interactive/2020/espanol/estados-unidos/donald-trump-elecciones.html',
          urlToImage: 'https://static01.nyt.com/newsgraphics/2019/08/01/candidate-pages/7d63f01f112e79da7ac60c0448a4047a155ff410/trump.jpg',
          publishedAt: '2023-01-01T00:00:00Z',
          content: 'Content of Mock Article 1',
        ),
        const ArticleEntity(
          id: 2,
          author: 'Author 2',
          title: 'Mock Article 2',
          description: 'Description of Mock Article 2',
          url: 'https://www.nytimes.com/es/interactive/2020/espanol/estados-unidos/donald-trump-elecciones.html',
          urlToImage: 'https://static01.nyt.com/newsgraphics/2019/08/01/candidate-pages/7d63f01f112e79da7ac60c0448a4047a155ff410/trump.jpg',
          publishedAt: '2023-01-02T00:00:00Z',
          content: 'Content of Mock Article 2',
        ),
      ];

      return DataSuccess(articles);
    } catch (e) {
      // Ensure that the error is of type DioError or create a default DioError
      if (e is DioError) {
        return DataFailed(e);  // Pass DioError
      } else {
        return DataFailed(DioError(
          requestOptions: RequestOptions(path: ''),
          error: 'Unknown error',
        ));
      }
    }
  }

  @override
  Future<List<ArticleEntity>> getSavedArticles() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return [
      const ArticleEntity(
        id: 1,
        author: 'Saved Author',
        title: 'Saved Mock Article',
        description: 'Saved Mock Article Description',
        url: 'https://www.nytimes.com/es/interactive/2020/espanol/estados-unidos/donald-trump-elecciones.html',
        urlToImage: 'https://static01.nyt.com/newsgraphics/2019/08/01/candidate-pages/7d63f01f112e79da7ac60c0448a4047a155ff410/trump.jpg',
        publishedAt: '2023-02-01T00:00:00Z',
        content: 'Saved Mock Article Content',
      ),
    ];
  }

  @override
  Future<void> saveArticle(ArticleEntity article) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
  }

  @override
  Future<void> removeArticle(ArticleEntity article) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
  }
}
