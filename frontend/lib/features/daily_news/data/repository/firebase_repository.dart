import 'package:dio/dio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';

class FirebaseArticleRepository implements ArticleRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Future<DataState<List<ArticleEntity>>> getNewsArticles() async {
    try {
      final snapshot = await _firestore.collection('articles').get();
      final articles = snapshot.docs.map((doc) {
        final data = doc.data();
        return ArticleEntity(
          id: data['id'] as int,
          author: data['author'] as String,
          title: data['title'] as String,
          description: data['description'] as String,
          url: data['url'] ?? '',
          urlToImage: data['urlToImage'] ?? '',
          publishedAt: data['publishedAt'] as String,
          content: data['content'] as String,
        );
      }).toList();
      return DataSuccess(articles);
    } catch (e) {
      return DataFailed(
        // Using DioError to wrap error, as in your original code.
        DioError(requestOptions: RequestOptions(path: ''), error: e.toString()),
      );
    }
  }

  @override
  Future<List<ArticleEntity>> getSavedArticles() async {
    throw UnimplementedError();
  }

  @override
  Future<void> saveArticle(ArticleEntity article) async {
    throw UnimplementedError();
  }

  @override
  Future<void> removeArticle(ArticleEntity article) async {
    throw UnimplementedError();
  }

  @override
  Future<void> submitArticle(ArticleEntity article) async {
    // Simply use the URL provided in the ArticleEntity.
    final docId = article.id.toString();
    await _firestore.collection('articles').doc(docId).set({
      'id': article.id,
      'author': article.author,
      'title': article.title,
      'description': article.description,
      'url': article.url,
      'urlToImage': article.urlToImage, // This should be the valid remote URL
      'publishedAt': article.publishedAt,
      'content': article.content,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
