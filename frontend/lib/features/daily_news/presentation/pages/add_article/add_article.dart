import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/cubits/add_article_cubit.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/cubits/image_picker_cubit.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/article_form.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/image_picker_widget.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';

final sl = GetIt.instance;

class AddArticlePage extends StatelessWidget {
  const AddArticlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AddArticleCubit(
            context.read<LocalArticleBloc>(),
            sl<ArticleRepository>(),
          ),
        ),
        BlocProvider(create: (context) => ImagePickerCubit()),
      ],
      child: const AddArticlePageBody(),
    );
  }
}

class AddArticlePageBody extends StatefulWidget {
  const AddArticlePageBody({Key? key}) : super(key: key);

  @override
  _AddArticlePageBodyState createState() => _AddArticlePageBodyState();
}

class _AddArticlePageBodyState extends State<AddArticlePageBody> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  // Use Uint8List to store the selected image bytes.
  Uint8List? _selectedImage;

  // Updated callback: parameter is Uint8List? (not ImageData?)
  void _onImagePicked(Uint8List? image) {
    setState(() {
      _selectedImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddArticleCubit, LocalArticlesState>(
      listener: (context, state) {
        if (state is ArticleSubmissionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Article submitted successfully!')),
          );
          Navigator.pop(context, true);
        } else if (state is ArticleSubmissionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.error}')),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Add New Article"),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ArticleForm(
                      formKey: _formKey,
                      titleController: _titleController,
                      descriptionController: _descriptionController,
                      contentController: _contentController,
                      onImagePicked:
                          _onImagePicked, // Now matches type void Function(Uint8List?)?
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: state is ArticleSubmissionLoading
                          ? null
                          : () => _onSubmit(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: state is ArticleSubmissionLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Submit Article",
                              style: TextStyle(fontSize: 16.0)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onSubmit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text;
      final description = _descriptionController.text;
      final content = _contentController.text;

      if (_selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please select an image for the article.')),
        );
        return;
      }

      // Wrap the selected image bytes in an ImageData object.
      // (Your cubit expects ImageData; see image_picker_cubit.dart for its definition.)
      final imageData = ImageData(
        bytes: _selectedImage!,
        name: "article_${DateTime.now().millisecondsSinceEpoch}.jpg",
      );

      context.read<AddArticleCubit>().submitArticle(
            title: title,
            description: description,
            content: content,
            imageData: imageData,
          );
    }
  }
}
