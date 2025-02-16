import 'dart:io';
import 'package:news_app_clean_architecture/core/usecase/usecase.dart';
import 'save_article_params.dart';
import '../repository/article_repository.dart';

class SaveArticleUseCase implements UseCase<void, SaveArticleParams> {
  final ArticleRepository _articleRepository;
  SaveArticleUseCase(this._articleRepository);

  @override
  Future<void> call({SaveArticleParams? params}) {
    // Call the repository with the article and the optional media file.
    return _articleRepository.saveArticle(params!.article,
        mediaFile: params.mediaFile);
  }
}
