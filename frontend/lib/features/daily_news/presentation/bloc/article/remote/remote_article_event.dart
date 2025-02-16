import 'dart:io';
import '../../../../domain/entities/article.dart';

abstract class RemoteArticlesEvent {
  const RemoteArticlesEvent();
}

class GetArticles extends RemoteArticlesEvent {
  const GetArticles();
}

// New event for submitting an article with an optional media file.
class SubmitArticleRemoteEvent extends RemoteArticlesEvent {
  final ArticleEntity article;
  final File? mediaFile;

  const SubmitArticleRemoteEvent(this.article, {this.mediaFile});
}
