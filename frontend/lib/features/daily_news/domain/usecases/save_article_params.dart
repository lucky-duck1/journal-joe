import 'dart:io';
import '../entities/article.dart';

class SaveArticleParams {
  final ArticleEntity article;
  final File? mediaFile;
  SaveArticleParams({required this.article, this.mediaFile});
}
