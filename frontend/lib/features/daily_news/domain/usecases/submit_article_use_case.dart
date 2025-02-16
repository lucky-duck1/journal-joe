import 'dart:io';
import 'package:news_app_clean_architecture/core/usecase/usecase.dart';
import 'save_article_params.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';

class SubmitArticleUseCase implements UseCase<void, SaveArticleParams> {
  final ArticleRepository _articleRepository;

  SubmitArticleUseCase(this._articleRepository);

  @override
  Future<void> call({SaveArticleParams? params}) {
    // Here, we delegate to the repository's submitArticle method.
    return _articleRepository.submitArticle(params!.article,
        mediaFile: params.mediaFile);
  }
}
