import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/article/local/image_picker_cubit.dart';

class ImagePickerWidget extends StatelessWidget {
  final void Function(File?)? onImagePicked;

  const ImagePickerWidget({Key? key, this.onImagePicked}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImagePickerCubit, File?>(
      builder: (context, selectedImage) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Picker Button
            ElevatedButton.icon(
              onPressed: () async {
                await context.read<ImagePickerCubit>().pickImage();
                onImagePicked?.call(context.read<ImagePickerCubit>().state);
              },
              icon: const Icon(Icons.photo),
              label: Text(
                  selectedImage == null ? "Pick an Image" : "Change Image"),
            ),
            const SizedBox(height: 10),

            // Show Image Preview (If Selected)
            if (selectedImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  selectedImage, // Local image (FileImage)
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else if (selectedImage == null &&
                context
                        .read<ImagePickerCubit>()
                        .state
                        ?.path
                        .startsWith('http') ==
                    true)
              // If selected image is a URL, use NetworkImage
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  context.read<ImagePickerCubit>().state?.path ?? '',
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else
              // Placeholder when no image is selected
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[300],
                  border: Border.all(color: Colors.grey),
                ),
                child: const Center(
                  child: Text("No Image Selected",
                      style: TextStyle(color: Colors.black54)),
                ),
              ),
          ],
        );
      },
    );
  }
}
