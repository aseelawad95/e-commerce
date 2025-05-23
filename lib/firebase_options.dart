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
    apiKey: 'AIzaSyBRMZcHXbnOCEdFZ0inQTCUb_pRfj-uVzA',
    appId: '1:339683284195:web:943467913934c3fcc821d6',
    messagingSenderId: '339683284195',
    projectId: 'e-commerce-da208',
    authDomain: 'e-commerce-da208.firebaseapp.com',
    storageBucket: 'e-commerce-da208.firebasestorage.app',
    measurementId: 'G-WD3FXSY316',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAy8tv5Lo6A9as-LmRboXk3nOjsHCLTgQI',
    appId: '1:339683284195:android:ae977577406a69dbc821d6',
    messagingSenderId: '339683284195',
    projectId: 'e-commerce-da208',
    storageBucket: 'e-commerce-da208.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAy2iC4Mm1sDT3yKNeEbPkAjvO_qE0GaF8',
    appId: '1:339683284195:ios:41ad0214c097f874c821d6',
    messagingSenderId: '339683284195',
    projectId: 'e-commerce-da208',
    storageBucket: 'e-commerce-da208.firebasestorage.app',
    iosBundleId: 'com.example.eCommerce',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAy2iC4Mm1sDT3yKNeEbPkAjvO_qE0GaF8',
    appId: '1:339683284195:ios:41ad0214c097f874c821d6',
    messagingSenderId: '339683284195',
    projectId: 'e-commerce-da208',
    storageBucket: 'e-commerce-da208.firebasestorage.app',
    iosBundleId: 'com.example.eCommerce',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBRMZcHXbnOCEdFZ0inQTCUb_pRfj-uVzA',
    appId: '1:339683284195:web:884a59ad710c729dc821d6',
    messagingSenderId: '339683284195',
    projectId: 'e-commerce-da208',
    authDomain: 'e-commerce-da208.firebaseapp.com',
    storageBucket: 'e-commerce-da208.firebasestorage.app',
    measurementId: 'G-XHJP2RNZQP',
  );
}
