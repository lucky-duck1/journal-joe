import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import '../../../../domain/entities/article.dart';

abstract class RemoteArticlesState extends Equatable {
  final List<ArticleEntity>? articles;
  final DioError? error;

  const RemoteArticlesState({this.articles, this.error});

  @override
  List<Object?> get props => [articles, error];
}

class RemoteArticlesLoading extends RemoteArticlesState {
  const RemoteArticlesLoading();
}

class RemoteArticlesDone extends RemoteArticlesState {
  const RemoteArticlesDone(List<ArticleEntity> articles)
      : super(articles: articles);
}

class RemoteArticlesError extends RemoteArticlesState {
  const RemoteArticlesError(DioError error) : super(error: error);
}

// New states for submission
class RemoteArticleSubmissionLoading extends RemoteArticlesState {
  const RemoteArticleSubmissionLoading();
}

class RemoteArticleSubmissionSuccess extends RemoteArticlesState {
  const RemoteArticleSubmissionSuccess();
}

class RemoteArticleSubmissionError extends RemoteArticlesState {
  final String errorMessage;
  const RemoteArticleSubmissionError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
