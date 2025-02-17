import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerCubit extends Cubit<ImageData?> {
  final ImagePicker _picker = ImagePicker();

  ImagePickerCubit() : super(null);

  Future<void> pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final Uint8List bytes = await pickedFile.readAsBytes();
      emit(ImageData(bytes: bytes, name: pickedFile.name));
    }
  }

  void clearImage() {
    emit(null);
  }
}

class ImageData {
  final Uint8List bytes;
  final String name;

  ImageData({required this.bytes, required this.name});
}
