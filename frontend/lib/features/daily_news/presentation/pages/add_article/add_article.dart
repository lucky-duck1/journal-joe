import 'dart:io'; // For File handling
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/article.dart';
import '../../bloc/article/local/add_article_cubit.dart';
import '../../bloc/article/local/image_picker_cubit.dart';
import '../../bloc/article/local/local_article_bloc.dart';
import '../../bloc/article/local/local_article_state.dart';
import '../../widgets/article_form.dart';
import '../../widgets/image_picker_widget.dart'; // The custom image picker widget

class AddArticlePage extends StatelessWidget {
  const AddArticlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                AddArticleCubit(context.read<LocalArticleBloc>())),
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
  File? _selectedImage;

  // Handle image picking
  void _onImagePicked(File? image) {
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
                      onImagePicked: _onImagePicked, // Image picking callback
                    ),
                    const SizedBox(height: 16),

                    // Submit Button
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

      context.read<AddArticleCubit>().submitArticle(
            title: title,
            description: description,
            content: content,
            imageFile: _selectedImage, // Pass the selected image
          );
    }
  }
}
