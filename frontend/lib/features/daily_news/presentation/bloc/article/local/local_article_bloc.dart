import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_state.dart';
import '../../../../domain/usecases/get_saved_article.dart';
import '../../../../domain/usecases/remove_article.dart';
import '../../../../domain/usecases/save_article.dart';
import '../../../../domain/repository/article_repository.dart';

class LocalArticleBloc extends Bloc<LocalArticlesEvent, LocalArticlesState> {
  final GetSavedArticleUseCase _getSavedArticleUseCase;
  final SaveArticleUseCase _saveArticleUseCase;
  final RemoveArticleUseCase _removeArticleUseCase;
  final ArticleRepository _articleRepository; // Ensure repository is injected

  LocalArticleBloc(
    this._getSavedArticleUseCase,
    this._saveArticleUseCase,
    this._removeArticleUseCase,
    this._articleRepository,
  ) : super(const LocalArticlesLoading()) {
    on<GetSavedArticles>(_onGetSavedArticles);
    on<RemoveArticle>(_onRemoveArticle);
    on<SaveArticle>(_onSaveArticle);
    on<SubmitArticleEvent>(
        _onSubmitArticle); // Add handler for SubmitArticleEvent
  }

  /// Fetch saved articles
  Future<void> _onGetSavedArticles(
      GetSavedArticles event, Emitter<LocalArticlesState> emit) async {
    try {
      final articles = await _getSavedArticleUseCase();
      emit(LocalArticlesDone(articles));
    } catch (e) {
      emit(LocalArticlesError(
          'Failed to fetch saved articles: ${e.toString()}'));
    }
  }

  /// Remove article from saved list
  Future<void> _onRemoveArticle(
      RemoveArticle event, Emitter<LocalArticlesState> emit) async {
    try {
      await _removeArticleUseCase(
          params: event.article); // Remove from database
      final updatedArticles = await _getSavedArticleUseCase(); // Fetch new list
      emit(const ArticleSubmissionSuccess());
      emit(LocalArticlesDone(updatedArticles)); // Refresh UI with updated list
    } catch (e) {
      emit(LocalArticlesError('Failed to remove article: ${e.toString()}'));
    }
  }

  /// Save article to saved articles
  Future<void> _onSaveArticle(
      SaveArticle event, Emitter<LocalArticlesState> emit) async {
    try {
      emit(LocalArticlesLoading());
      await _saveArticleUseCase(params: event.article);
      final articles = await _getSavedArticleUseCase();
      emit(LocalArticlesDone(articles));
    } catch (e) {
      emit(LocalArticlesError('Failed to save article: ${e.toString()}'));
    }
  }

  /// Submit a new article to the repository
  Future<void> _onSubmitArticle(
      SubmitArticleEvent event, Emitter<LocalArticlesState> emit) async {
    try {
      emit(ArticleSubmissionLoading());

      await _articleRepository.submitArticle(event.article);

      // Fetch updated articles after submission
      final updatedArticles = await _articleRepository.getNewsArticles();

      emit(ArticleSubmissionSuccess()); // Show success first
      emit(
          LocalArticlesDone(updatedArticles.data ?? [])); // Update article list
    } catch (e) {
      emit(ArticleSubmissionError('Failed to submit article: ${e.toString()}'));
    }
  }
}
