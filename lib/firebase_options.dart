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
        return macos;
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
    apiKey: 'AIzaSyA8DJX6nZU7-vXS2DAFCkndocQU0gMI30M',
    appId: '1:218396032450:web:cbaad378ce87d19f2daa5b',
    messagingSenderId: '218396032450',
    projectId: 'chatappflutter-97347',
    authDomain: 'chatappflutter-97347.firebaseapp.com',
    storageBucket: 'chatappflutter-97347.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDrltGakpZtvxdoLoOXHaKA_gH-GvPbjKw',
    appId: '1:218396032450:android:5607e811530f32342daa5b',
    messagingSenderId: '218396032450',
    projectId: 'chatappflutter-97347',
    storageBucket: 'chatappflutter-97347.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyALSOL1akjLIOqAMA80t8-q5oHKpRrLdW0',
    appId: '1:218396032450:ios:baddf17ab308040d2daa5b',
    messagingSenderId: '218396032450',
    projectId: 'chatappflutter-97347',
    storageBucket: 'chatappflutter-97347.appspot.com',
    iosClientId: '218396032450-tfqlodrra5csr8hl40egloju9bmcgu02.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatappfirebasemit',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyALSOL1akjLIOqAMA80t8-q5oHKpRrLdW0',
    appId: '1:218396032450:ios:302310b54ee079652daa5b',
    messagingSenderId: '218396032450',
    projectId: 'chatappflutter-97347',
    storageBucket: 'chatappflutter-97347.appspot.com',
    iosClientId: '218396032450-lb8te6dn13mmp9gpak5afjsug5cnl4a8.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatappfirebasemit.RunnerTests',
  );
}