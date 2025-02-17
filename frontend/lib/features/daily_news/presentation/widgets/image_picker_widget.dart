import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/cubits/image_picker_cubit.dart';

class ImagePickerWidget extends StatelessWidget {
  // Callback now passes a Uint8List (raw image bytes) to the parent
  final void Function(Uint8List?)? onImagePicked;

  const ImagePickerWidget({Key? key, this.onImagePicked}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImagePickerCubit, ImageData?>(
      builder: (context, imageData) {
        return GestureDetector(
          onTap: () async {
            await context.read<ImagePickerCubit>().pickImage();
            if (onImagePicked != null) {
              // Pass the raw bytes to the parent
              onImagePicked!(context.read<ImagePickerCubit>().state?.bytes);
            }
          },
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey),
            ),
            child: imageData == null
                ? const Center(
                    child: Text('No Image Selected',
                        style: TextStyle(color: Colors.black54)),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(
                      imageData.bytes,
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
