// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAs7274M64xR9pvmlm7XMTqM6PMLo7sXKo',
    appId: '1:663532848809:web:7bf0463a99049884bd8bb8',
    messagingSenderId: '663532848809',
    projectId: 'fir-a0a49',
    authDomain: 'fir-a0a49.firebaseapp.com',
    storageBucket: 'fir-a0a49.appspot.com',
    measurementId: 'G-TVPG0V7S3M',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCNFNi6s43Rm1heDvufF4b8_KxonmcwQ-Y',
    appId: '1:663532848809:android:150179dc02f5d666bd8bb8',
    messagingSenderId: '663532848809',
    projectId: 'fir-a0a49',
    storageBucket: 'fir-a0a49.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDuXQ8rub21HdwQ73vNePeoiXQ9XSujU-o',
    appId: '1:663532848809:ios:13fd47968a132bb8bd8bb8',
    messagingSenderId: '663532848809',
    projectId: 'fir-a0a49',
    storageBucket: 'fir-a0a49.appspot.com',
    iosBundleId: 'com.example.calendarapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDuXQ8rub21HdwQ73vNePeoiXQ9XSujU-o',
    appId: '1:663532848809:ios:13fd47968a132bb8bd8bb8',
    messagingSenderId: '663532848809',
    projectId: 'fir-a0a49',
    storageBucket: 'fir-a0a49.appspot.com',
    iosBundleId: 'com.example.calendarapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAs7274M64xR9pvmlm7XMTqM6PMLo7sXKo',
    appId: '1:663532848809:web:ac3004f94e5948edbd8bb8',
    messagingSenderId: '663532848809',
    projectId: 'fir-a0a49',
    authDomain: 'fir-a0a49.firebaseapp.com',
    storageBucket: 'fir-a0a49.appspot.com',
    measurementId: 'G-L5B6T7PQPC',
  );
}
