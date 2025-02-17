import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerCubit extends Cubit<File?> {
  final ImagePicker _picker = ImagePicker();

  ImagePickerCubit() : super(null);

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Directly work with the file path
      emit(File(pickedFile.path));
    }
  }

  void clearImage() {
    emit(null); // ✅ Reset selected image
  }
}
