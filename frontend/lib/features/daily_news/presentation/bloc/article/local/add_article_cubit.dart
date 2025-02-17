import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../domain/entities/article.dart';
import '../../../../domain/repository/article_repository.dart'; // Import the repository
import 'local_article_event.dart';
import 'local_article_state.dart';
import 'local_article_bloc.dart';

class AddArticleCubit extends Cubit<LocalArticlesState> {
  final LocalArticleBloc _localArticleBloc;
  final ArticleRepository _articleRepository; // Add this

  AddArticleCubit(this._localArticleBloc, this._articleRepository)
      : super(LocalArticlesInitial()); // Update constructor

  Future<void> submitArticle({
    required String title,
    required String description,
    required String content,
    File? imageFile,
  }) async {
    if (title.isEmpty || description.isEmpty || content.isEmpty) {
      emit(const ArticleSubmissionError("All fields are required."));
      return;
    }

    emit(const ArticleSubmissionLoading());

    String imagePath = "";
    if (imageFile != null) {
      imagePath = await _saveImageLocally(imageFile); // Save locally
    }

    final newArticle = ArticleEntity(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      description: description,
      content: content,
      author: "New Author",
      url: "",
      urlToImage: imagePath, // Stores the correct local path
      publishedAt: DateTime.now().toIso8601String(),
    );

    try {
      await _articleRepository.submitArticle(newArticle); // Submit to Firebase
      _localArticleBloc
          .add(SubmitArticleEvent(newArticle)); // Keep local submission

      emit(const ArticleSubmissionSuccess());
    } catch (e) {
      emit(ArticleSubmissionError(e.toString()));
    }
  }

  Future<String> _saveImageLocally(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = imageFile.uri.pathSegments.last;
    final savedImagePath = '${directory.path}/$fileName';

    final localImage = await imageFile.copy(savedImagePath);
    return localImage.path;
  }
}
