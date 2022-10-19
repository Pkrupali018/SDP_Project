// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBTFXXl5o6IIhXUmTV3pvSIIiB1uY4_y-Y',
    appId: '1:532415976358:web:0ff0cf749eb3229babb567',
    messagingSenderId: '532415976358',
    projectId: 'lookup-d9660',
    authDomain: 'lookup-d9660.firebaseapp.com',
    storageBucket: 'lookup-d9660.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDdvdAtRearPxpMwYRL6nhBEtKtJUtjszw',
    appId: '1:532415976358:android:7f3d323d9ed3a721abb567',
    messagingSenderId: '532415976358',
    projectId: 'lookup-d9660',
    storageBucket: 'lookup-d9660.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBw5WmjU6MPPcBniqxnOq8Ra-4lQfKDHfU',
    appId: '1:532415976358:ios:93d2387a065a55f2abb567',
    messagingSenderId: '532415976358',
    projectId: 'lookup-d9660',
    storageBucket: 'lookup-d9660.appspot.com',
    iosClientId: '532415976358-vp5u4vj788rvb9e177qng9cam8hl5cql.apps.googleusercontent.com',
    iosBundleId: 'com.example.lookup',
  );
}