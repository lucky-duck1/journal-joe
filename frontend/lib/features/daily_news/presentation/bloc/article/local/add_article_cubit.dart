import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart'; // ✅ For local storage
import '../../../../domain/entities/article.dart';
import 'local_article_event.dart';
import 'local_article_state.dart';
import 'local_article_bloc.dart';

class AddArticleCubit extends Cubit<LocalArticlesState> {
  final LocalArticleBloc _localArticleBloc;

  AddArticleCubit(this._localArticleBloc) : super(LocalArticlesInitial());

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
      imagePath = await _saveImageLocally(imageFile); // ✅ Save locally
    }

    final newArticle = ArticleEntity(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      description: description,
      content: content,
      author: "New Author",
      url: "",
      urlToImage: imagePath, // ✅ Stores the correct local path
      publishedAt: DateTime.now().toIso8601String(),
    );

    _localArticleBloc.add(SubmitArticleEvent(newArticle));

    emit(const ArticleSubmissionSuccess());
  }

  // ✅ Save the image locally and return the new path
  Future<String> _saveImageLocally(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = imageFile.uri.pathSegments.last;
    final savedImagePath = '${directory.path}/$fileName';

    final localImage = await imageFile.copy(savedImagePath);
    return localImage.path; // ✅ Returns local path
  }
}
