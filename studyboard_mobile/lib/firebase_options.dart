// PLACEHOLDER — replace this file with the output from `flutterfire configure`
// once the StudyBoard Firebase project has been created.
//
// Run:  flutterfire configure --project=<your-studyboard-firebase-project>
//
// The values below are intentionally invalid to prevent accidental use of
// credentials belonging to another project.
//
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyCWsHKUtTrY3beIMZBtP2HQL9yLHxt9FBs',
    appId: '1:719373400195:web:03729641759fe49b3903b6',
    messagingSenderId: '719373400195',
    projectId: 'nursing-log-app',
    authDomain: 'nursing-log-app.firebaseapp.com',
    databaseURL: 'https://nursing-log-app.firebaseio.com',
    storageBucket: 'nursing-log-app.firebasestorage.app',
  );

  // Replace with real values: Firebase Console → Project Settings → Your apps

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA30opVwnux6JVY6fBmIp-3b-oiFvLvSKY',
    appId: '1:719373400195:android:59f55009460ca2273903b6',
    messagingSenderId: '719373400195',
    projectId: 'nursing-log-app',
    databaseURL: 'https://nursing-log-app.firebaseio.com',
    storageBucket: 'nursing-log-app.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD_49pUW9WEhVEvMLmZopHd-1U-zzX-Q00',
    appId: '1:719373400195:ios:3e8c8c59631e8a4b3903b6',
    messagingSenderId: '719373400195',
    projectId: 'nursing-log-app',
    databaseURL: 'https://nursing-log-app.firebaseio.com',
    storageBucket: 'nursing-log-app.firebasestorage.app',
    iosClientId: '719373400195-g6omrteoltob2o7kkcc7iuttr1q0v8ss.apps.googleusercontent.com',
    iosBundleId: 'com.lahiru.studyboard.studyboard-mobile',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD_49pUW9WEhVEvMLmZopHd-1U-zzX-Q00',
    appId: '1:719373400195:ios:5123335592b550a63903b6',
    messagingSenderId: '719373400195',
    projectId: 'nursing-log-app',
    databaseURL: 'https://nursing-log-app.firebaseio.com',
    storageBucket: 'nursing-log-app.firebasestorage.app',
    iosClientId: '719373400195-61uoas3ktvcsnum9jp02mknlm78q34gj.apps.googleusercontent.com',
    iosBundleId: 'com.example.myApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCWsHKUtTrY3beIMZBtP2HQL9yLHxt9FBs',
    appId: '1:719373400195:web:7f7d42f11d5f50373903b6',
    messagingSenderId: '719373400195',
    projectId: 'nursing-log-app',
    authDomain: 'nursing-log-app.firebaseapp.com',
    databaseURL: 'https://nursing-log-app.firebaseio.com',
    storageBucket: 'nursing-log-app.firebasestorage.app',
  );

}