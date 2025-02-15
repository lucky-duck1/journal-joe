import 'dart:io';  // ✅ Import for File
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
        _selectedImage = File(pickedImage.path);  // ✅ Convert XFile to File
      });
      if (widget.onImagePicked != null) {
        widget.onImagePicked!(_selectedImage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          TextFormField(
            controller: widget.titleController,
            decoration: const InputDecoration(labelText: 'Title'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Title cannot be empty';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: widget.descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Description cannot be empty';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: widget.contentController,
            decoration: const InputDecoration(labelText: 'Content (Markdown Supported)'),
            maxLines: 5,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Content cannot be empty';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _pickImage,
            child: const Text("Pick an Image"),
          ),
          if (_selectedImage != null) ...[
            const SizedBox(height: 8),
            Image.file(
              _selectedImage!,
              height: 100,
              fit: BoxFit.cover,
            ),
          ],
        ],
      ),
    );
  }
}
