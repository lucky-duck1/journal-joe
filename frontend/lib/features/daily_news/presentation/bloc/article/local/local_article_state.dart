import 'package:equatable/equatable.dart';
import '../../../../domain/entities/article.dart';

// Abstract Base State Class
abstract class LocalArticlesState extends Equatable {
  final List<ArticleEntity> articles;
  final String? error;

  const LocalArticlesState({this.articles = const [], this.error});

  @override
  List<Object?> get props => [articles, error];
}

class LocalArticlesInitial extends LocalArticlesState {
  const LocalArticlesInitial();
}

// Loading State
class LocalArticlesLoading extends LocalArticlesState {
  const LocalArticlesLoading();
}

// Success State (Articles successfully loaded or saved)
class LocalArticlesDone extends LocalArticlesState {
  const LocalArticlesDone(List<ArticleEntity> articles)
      : super(articles: articles);
}

// Error State (If there's an error during the operation)
class LocalArticlesError extends LocalArticlesState {
  const LocalArticlesError(String error) : super(error: error);
}

/// ✅ New States for Article Submission
class ArticleSubmissionLoading extends LocalArticlesState {
  const ArticleSubmissionLoading();
}

class ArticleSubmissionSuccess extends LocalArticlesState {
  const ArticleSubmissionSuccess();
}

class ArticleSubmissionError extends LocalArticlesState {
  final String error;
  const ArticleSubmissionError(this.error);
}
