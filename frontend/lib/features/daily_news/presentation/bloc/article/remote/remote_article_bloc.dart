import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/save_article_params.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/submit_article_use_case.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';

class RemoteArticlesBloc
    extends Bloc<RemoteArticlesEvent, RemoteArticlesState> {
  final GetArticleUseCase _getArticleUseCase;
  final SubmitArticleUseCase _submitArticleUseCase;

  RemoteArticlesBloc(
    this._getArticleUseCase,
    this._submitArticleUseCase,
  ) : super(const RemoteArticlesLoading()) {
    on<GetArticles>(_onGetArticles);
    on<SubmitArticleRemoteEvent>(_onSubmitArticle);
  }

  void _onGetArticles(
      GetArticles event, Emitter<RemoteArticlesState> emit) async {
    final dataState = await _getArticleUseCase();
    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(RemoteArticlesDone(dataState.data!));
    } else if (dataState is DataFailed) {
      emit(RemoteArticlesError(dataState.error!));
    }
  }

  Future<void> _onSubmitArticle(
    SubmitArticleRemoteEvent event,
    Emitter<RemoteArticlesState> emit,
  ) async {
    try {
      emit(const RemoteArticleSubmissionLoading());
      // Build the parameters, including the optional media file
      final params = SaveArticleParams(
        article: event.article,
        mediaFile: event.mediaFile,
      );
      await _submitArticleUseCase(params: params);
      emit(const RemoteArticleSubmissionSuccess());

      // Optionally, refresh the articles list after submission
      final dataState = await _getArticleUseCase();
      if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
        emit(RemoteArticlesDone(dataState.data!));
      }
    } catch (e) {
      emit(RemoteArticleSubmissionError(e.toString()));
    }
  }
}
