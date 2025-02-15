import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/article.dart';
import '../../bloc/article/local/local_article_bloc.dart';
import '../../bloc/article/local/local_article_event.dart';
import '../../bloc/article/local/local_article_state.dart';
import '../../widgets/article_form.dart';

class AddArticlePage extends StatelessWidget {
  const AddArticlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          context.read<LocalArticleBloc>(), // ✅ Provide Bloc here
      child: const AddArticlePageBody(),
    );
  }
}

class AddArticlePageBody extends StatefulWidget {
  const AddArticlePageBody({Key? key}) : super(key: key);

  @override
  _AddArticlePageState createState() => _AddArticlePageState();
}

class _AddArticlePageState extends State<AddArticlePageBody> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Article"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<LocalArticleBloc, LocalArticlesState>(
        listener: (context, state) {
          if (state is ArticleSubmissionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Article submitted successfully!')),
            );
            Navigator.pop(context); // ✅ Close page after success
          } else if (state is ArticleSubmissionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
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
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed:
                          state is ArticleSubmissionLoading ? null : _onSubmit,
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
          );
        },
      ),
    );
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final newArticle = ArticleEntity(
        id: DateTime.now().millisecondsSinceEpoch, // Unique ID
        title: _titleController.text,
        description: _descriptionController.text,
        content: _contentController.text,
        author: "New Author",
        url: "",
        urlToImage: "",
        publishedAt: DateTime.now().toIso8601String(),
      );

      context
          .read<LocalArticleBloc>()
          .add(SubmitArticleEvent(newArticle)); // ✅ Dispatch event
    }
  }
}
