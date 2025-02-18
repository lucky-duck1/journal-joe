// File generated manually
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web; // ✅ Added Web Support
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for this platform - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCIDEnhycnZSeEuJwyzvP-7nuKlNXB5M7w',
    authDomain: 'journal-joe-fd4de.firebaseapp.com',
    databaseURL: 'https://journal-joe-fd4de-default-rtdb.firebaseio.com',
    projectId: 'journal-joe-fd4de',
    storageBucket:
        'journal-joe-fd4de.firebasestorage.app', // ✅ Fixed storageBucket
    messagingSenderId: '627624562634',
    appId: '1:627624562634:web:0ea45d4c10a0a1ccf00933',
    measurementId: 'G-3JNVQPJWXW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyArBA6cs3YYl72jIYHYiZSpoNCl0fDvZz0',
    appId: '1:627624562634:android:e4f86e12ea008465f00933',
    messagingSenderId: '627624562634',
    projectId: 'journal-joe-fd4de',
    databaseURL: 'https://journal-joe-fd4de-default-rtdb.firebaseio.com',
    storageBucket:
        'journal-joe-fd4de.firebasestorage.app', // ✅ Fixed storageBucket
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDJOs6kV2GT68zREntv9M3ZedEsRP_N3S0',
    appId: '1:627624562634:ios:cc7d2aff8b00143cf00933',
    messagingSenderId: '627624562634',
    projectId: 'journal-joe-fd4de',
    databaseURL: 'https://journal-joe-fd4de-default-rtdb.firebaseio.com',
    storageBucket:
        'journal-joe-fd4de.firebasestorage.app', // ✅ Fixed storageBucket
    iosBundleId: 'com.example.frontend',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDJOs6kV2GT68zREntv9M3ZedEsRP_N3S0',
    appId: '1:627624562634:ios:cc7d2aff8b00143cf00933',
    messagingSenderId: '627624562634',
    projectId: 'journal-joe-fd4de',
    databaseURL: 'https://journal-joe-fd4de-default-rtdb.firebaseio.com',
    storageBucket:
        'journal-joe-fd4de.firebasestorage.app', // ✅ Fixed storageBucket
    iosBundleId: 'com.example.frontend',
  );
}
