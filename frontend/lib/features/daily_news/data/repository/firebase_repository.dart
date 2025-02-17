import 'dart:io';
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
      return DataFailed(DioError(
          requestOptions: RequestOptions(path: ''), error: e.toString()));
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
    String? imageUrl;
    if (article.urlToImage != null && article.urlToImage!.isNotEmpty) {
      final file = File(article.urlToImage!);
      if (await file.exists()) {
        try {
          final fileName = file.uri.pathSegments.last;
          final ref = _storage.ref().child('articles_images/$fileName');
          final uploadTask = await ref.putFile(file);
          imageUrl = await uploadTask.ref.getDownloadURL();
        } catch (e) {
          print("Image upload failed: $e"); // Handle upload failure
        }
      }
    }

    final docId = article.id.toString();

    await _firestore.collection('articles').doc(docId).set({
      'id': article.id,
      'author': article.author,
      'title': article.title,
      'description': article.description,
      'url': article.url,
      'urlToImage': imageUrl ?? '',
      'publishedAt': article.publishedAt,
      'content': article.content,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
