import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/models/article.dart';

class FirebaseArticleDataSource {
  final FirebaseFirestore firestore;

  FirebaseArticleDataSource({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> saveArticle(ArticleModel article) async {
    await firestore
        .collection('articles')
        .doc(article.id.toString())
        .set(article.toJson());
  }

  Future<List<ArticleModel>> getSavedArticles() async {
    final querySnapshot = await firestore.collection('articles').get();
    return querySnapshot.docs
        .map((doc) => ArticleModel.fromJson(doc.data()))
        .toList();
  }

  Future<void> removeArticle(String articleId) async {
    await firestore.collection('articles').doc(articleId).delete();
  }
}
