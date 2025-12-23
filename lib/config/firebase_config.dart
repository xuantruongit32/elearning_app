import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearning_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseConfig {
  static Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }
}
