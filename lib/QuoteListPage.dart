import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuoteListPage extends StatelessWidget {
  const QuoteListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shared Quotes")),
      body: StreamBuilder<QuerySnapshot>(
        // Mandatory: Fetching data from Firestore 
        stream: FirebaseFirestore.instance
            .collection('quotes')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text("Error loading data"));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(data['text'] ?? 'No Quote'),
                subtitle: Text("- ${data['author']} [${data['category']}]"),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}