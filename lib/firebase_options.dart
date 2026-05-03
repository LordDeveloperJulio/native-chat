import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) throw UnsupportedError('Web not supported.');
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBON1x8EJe1TYTyC9DLwR68-MkKUobe4pg',
    appId: '1:817371748592:android:abcdd40542b6f654478a35',
    messagingSenderId: '817371748592',
    projectId: 'native-chat-cfaf1',
    storageBucket: 'native-chat-cfaf1.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyClfGbWtn9cAsfMoFlV1-9FEGGIcgjth-M',
    appId: '1:817371748592:ios:347d6ebed57e1166478a35',
    messagingSenderId: '817371748592',
    projectId: 'native-chat-cfaf1',
    storageBucket: 'native-chat-cfaf1.firebasestorage.app',
    iosBundleId: 'com.bytecide.studyenglish.studyEnglish',
  );
}
