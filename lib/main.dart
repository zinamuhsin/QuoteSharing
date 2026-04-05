import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'quote_list_page.dart'; // Page to show quotes

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quote Sharing App',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: QuoteListPage(), // Start with the quotes list
    );
  }
}