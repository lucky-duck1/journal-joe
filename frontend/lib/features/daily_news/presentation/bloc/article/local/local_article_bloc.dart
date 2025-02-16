import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_state.dart';
import '../../../../domain/usecases/get_saved_article.dart';
import '../../../../domain/usecases/remove_article.dart';
import '../../../../domain/usecases/save_article.dart';
import '../../../../domain/usecases/save_article_params.dart';
import '../../../../domain/repository/article_repository.dart';

class LocalArticleBloc extends Bloc<LocalArticlesEvent, LocalArticlesState> {
  final GetSavedArticleUseCase _getSavedArticleUseCase;
  final SaveArticleUseCase _saveArticleUseCase;
  final RemoveArticleUseCase _removeArticleUseCase;
  final ArticleRepository _articleRepository;

  LocalArticleBloc(
    this._getSavedArticleUseCase,
    this._saveArticleUseCase,
    this._removeArticleUseCase,
    this._articleRepository,
  ) : super(const LocalArticlesLoading()) {
    on<GetSavedArticles>(_onGetSavedArticles);
    on<RemoveArticle>(_onRemoveArticle);
    on<SaveArticle>(_onSaveArticle);
    on<SubmitArticleEvent>(_onSubmitArticle);
  }

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

  Future<void> _onRemoveArticle(
      RemoveArticle event, Emitter<LocalArticlesState> emit) async {
    try {
      await _removeArticleUseCase(params: event.article);
      final updatedArticles = await _getSavedArticleUseCase();
      emit(const ArticleSubmissionSuccess());
      emit(LocalArticlesDone(updatedArticles));
    } catch (e) {
      emit(LocalArticlesError('Failed to remove article: ${e.toString()}'));
    }
  }

  Future<void> _onSaveArticle(
      SaveArticle event, Emitter<LocalArticlesState> emit) async {
    try {
      emit(LocalArticlesLoading());
      // Wrap the article and media file in SaveArticleParams.
      await _saveArticleUseCase(
        params: SaveArticleParams(
            article: event.article!, mediaFile: event.mediaFile),
      );
      final articles = await _getSavedArticleUseCase();
      emit(LocalArticlesDone(articles));
    } catch (e) {
      emit(LocalArticlesError('Failed to save article: ${e.toString()}'));
    }
  }

  Future<void> _onSubmitArticle(
      SubmitArticleEvent event, Emitter<LocalArticlesState> emit) async {
    try {
      emit(ArticleSubmissionLoading());
      // Pass the mediaFile along with the article.
      await _articleRepository.submitArticle(event.article!,
          mediaFile: event.mediaFile);
      final updatedArticles = await _articleRepository.getNewsArticles();
      emit(ArticleSubmissionSuccess());
      emit(LocalArticlesDone(updatedArticles.data ?? []));
    } catch (e) {
      emit(ArticleSubmissionError('Failed to submit article: ${e.toString()}'));
    }
  }
}
