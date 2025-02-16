import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class MediaService {
  final FirebaseStorage storage;

  MediaService({FirebaseStorage? storage})
      : storage = storage ?? FirebaseStorage.instance;

  Future<String> uploadArticleMedia(File file, String fileName) async {
    final ref = storage.ref().child('media/articles/$fileName');
    final uploadTask = ref.putFile(file);
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> deleteArticleMedia(String fileName) async {
    final ref = storage.ref().child('media/articles/$fileName');
    await ref.delete();
  }
}
