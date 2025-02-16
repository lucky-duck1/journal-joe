import 'dart:io'; // ✅ Import for File handling
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ArticleForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController contentController;
  final void Function(File?)? onImagePicked;

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
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
      widget.onImagePicked?.call(_selectedImage);
    }
  }

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

          // Image Picker Widget (moved before description)
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey),
              ),
              child: _selectedImage == null
                  ? const Center(
                      child: Text('No Image Selected',
                          style: TextStyle(color: Colors.black54)))
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
            ),
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
