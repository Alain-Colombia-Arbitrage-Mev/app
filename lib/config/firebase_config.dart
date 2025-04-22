import 'package:firebase_core/firebase_core.dart';

class FirebaseConfig {
  static const String apiKey = "YOUR_API_KEY";
  static const String authDomain = "YOUR_AUTH_DOMAIN";
  static const String projectId = "YOUR_PROJECT_ID";
  static const String storageBucket = "YOUR_STORAGE_BUCKET";
  static const String messagingSenderId = "YOUR_MESSAGING_SENDER_ID";
  static const String appId = "YOUR_APP_ID";

  static final FirebaseOptions firebaseOptions = FirebaseOptions(
    apiKey: apiKey,
    authDomain: authDomain,
    projectId: projectId,
    storageBucket: storageBucket,
    messagingSenderId: messagingSenderId,
    appId: appId,
  );

  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp(options: firebaseOptions);
  }
}
