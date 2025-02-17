import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/image_picker_widget.dart';

class ArticleForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController contentController;
  // Changed callback type to accept Uint8List? (raw image bytes)
  final void Function(Uint8List?)? onImagePicked;

  const ArticleForm({
    Key? key,
    required this.formKey,
    required this.titleController,
    required this.descriptionController,
    required this.contentController,
    this.onImagePicked,
  }) : super(key: key);

  @override
  _ArticleFormState createState() => _ArticleFormState();
}

class _ArticleFormState extends State<ArticleForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Input
          TextFormField(
            controller: widget.titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
                value == null || value.isEmpty ? 'Title cannot be empty' : null,
          ),
          const SizedBox(height: 16),
          // Image Picker Widget
          ImagePickerWidget(
            onImagePicked: widget.onImagePicked,
          ),
          const SizedBox(height: 16),
          // Description Input
          TextFormField(
            controller: widget.descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            validator: (value) => value == null || value.isEmpty
                ? 'Description cannot be empty'
                : null,
          ),
          const SizedBox(height: 16),
          // Content Input
          TextFormField(
            controller: widget.contentController,
            decoration: const InputDecoration(
              labelText: 'Content of the article',
              border: OutlineInputBorder(),
            ),
            maxLines: 5,
            validator: (value) => value == null || value.isEmpty
                ? 'Content cannot be empty'
                : null,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
