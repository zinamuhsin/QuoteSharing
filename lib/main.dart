import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'quotesharing.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "PASTE_API_KEY_HERE",
      appId: "PASTE_APP_ID_HERE",
      messagingSenderId: "PASTE_SENDER_ID_HERE",
      projectId: "quote-sharing-app", // I see this from your screenshot URL
      authDomain: "quote-sharing-app.firebaseapp.com",
      storageBucket: "quote-sharing-app.appspot.com",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const QuoteForm(),
    );
  }
}