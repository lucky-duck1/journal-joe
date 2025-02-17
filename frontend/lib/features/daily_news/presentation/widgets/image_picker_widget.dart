import 'dart:io'; // For file handling
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/cubits/image_picker_cubit.dart';

class ImagePickerWidget extends StatelessWidget {
  final void Function(File?)? onImagePicked;

  const ImagePickerWidget({Key? key, this.onImagePicked}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImagePickerCubit, File?>(
      builder: (context, selectedImage) {
        return GestureDetector(
          onTap: () async {
            // Trigger image picker on tap of the image container
            await context.read<ImagePickerCubit>().pickImage();
            // Update the state with the new image if selected
            if (onImagePicked != null) {
              onImagePicked!(context.read<ImagePickerCubit>().state);
            }
          },
          child: Container(
            width: double.infinity,
            height: 200, // Adjust height as needed
            decoration: BoxDecoration(
              color: Colors.grey[300], // Background color for image holder
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey),
            ),
            child: selectedImage == null
                ? const Center(
                    child: Text('No Image Selected',
                        style: TextStyle(color: Colors.black54)))
                : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      selectedImage,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
