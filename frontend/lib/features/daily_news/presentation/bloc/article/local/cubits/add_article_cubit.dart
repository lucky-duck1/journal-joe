import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';
import 'image_picker_cubit.dart';

class AddArticleCubit extends Cubit<LocalArticlesState> {
  final LocalArticleBloc _localArticleBloc;
  final ArticleRepository _articleRepository;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  AddArticleCubit(this._localArticleBloc, this._articleRepository)
      : super(LocalArticlesInitial());

  Future<void> submitArticle({
    required String title,
    required String description,
    required String content,
    ImageData? imageData,
  }) async {
    if (title.isEmpty || description.isEmpty || content.isEmpty) {
      emit(const ArticleSubmissionError("All fields are required."));
      return;
    }

    emit(const ArticleSubmissionLoading());
    print("Starting article submission...");

    try {
      String imageUrl = "";
      if (imageData != null) {
        print("Uploading image: ${imageData.name}");
        final storageRef = _storage.ref().child('articles/${imageData.name}');
        final uploadTask = storageRef.putData(
          imageData.bytes,
          SettableMetadata(contentType: 'image/jpeg'),
        );
        final snapshot = await uploadTask.whenComplete(() {
          print("Image upload task completed.");
        });
        imageUrl = await snapshot.ref.getDownloadURL();
        print("Image URL retrieved: $imageUrl");
      } else {
        print("No image provided.");
      }

      final newArticle = ArticleEntity(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title,
        description: description,
        content: content,
        author: "New Author",
        url: "",
        urlToImage: imageUrl,
        publishedAt: DateTime.now().toIso8601String(),
      );
      print("Created new article with ID: ${newArticle.id}");

      print("Submitting article to Firestore...");
      await _articleRepository.submitArticle(newArticle);
      print("Article submitted to Firestore successfully.");

      _localArticleBloc.add(SubmitArticleEvent(newArticle));
      emit(const ArticleSubmissionSuccess());
      print("Article submission successful, state updated.");
    } catch (e) {
      print("Error during article submission: $e");
      emit(ArticleSubmissionError(e.toString()));
    }
  }
}
