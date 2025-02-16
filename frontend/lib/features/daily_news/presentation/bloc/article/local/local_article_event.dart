import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../../../domain/entities/article.dart';

abstract class LocalArticlesEvent extends Equatable {
  final ArticleEntity? article;
  final File? mediaFile;
  const LocalArticlesEvent({this.article, this.mediaFile});

  @override
  List<Object?> get props => [article, mediaFile];
}

class GetSavedArticles extends LocalArticlesEvent {
  const GetSavedArticles();
}

class RemoveArticle extends LocalArticlesEvent {
  const RemoveArticle(ArticleEntity article) : super(article: article);
}

class SaveArticle extends LocalArticlesEvent {
  // Updated to include an optional mediaFile parameter.
  const SaveArticle(ArticleEntity article, {File? mediaFile})
      : super(article: article, mediaFile: mediaFile);
}

class SubmitArticleEvent extends LocalArticlesEvent {
  // Updated to include an optional mediaFile parameter.
  const SubmitArticleEvent(ArticleEntity article, {File? mediaFile})
      : super(article: article, mediaFile: mediaFile);
}
