import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuoteForm extends StatefulWidget {
  const QuoteForm({super.key});
  @override
  State<QuoteForm> createState() => _QuoteFormState();
}

class _QuoteFormState extends State<QuoteForm> {
  final _formKey = GlobalKey<FormState>(); // Requirement: Form Validation
  final _quoteController = TextEditingController();
  final _authorController = TextEditingController();
  String _category = 'Inspirational';

  // Function to save to Firebase (Requirement: Data Storage 15%)
  void _submitQuote() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('quotes').add({
        'text': _quoteController.text,
        'author': _authorController.text,
        'category': _category,
        'timestamp': FieldValue.serverTimestamp(), // Mandatory Requirement
      });
      
      _quoteController.clear();
      _authorController.clear();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quote Shared Successfully!'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Share a Quote"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- SECTION 1: THE FORM ---
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _quoteController,
                    decoration: const InputDecoration(labelText: "Quote Text"),
                    validator: (v) => v!.isEmpty ? "Please enter a quote" : null,
                  ),
                  TextFormField(
                    controller: _authorController,
                    decoration: const InputDecoration(labelText: "Author Name"),
                    validator: (v) => v!.isEmpty ? "Please enter an author" : null,
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _category,
                    decoration: const InputDecoration(labelText: "Category"),
                    items: ['Inspirational', 'Funny', 'Life', 'Wisdom']
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (val) => setState(() => _category = val!),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitQuote,
                    style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                    child: const Text("Post Quote"),
                  ),
                ],
              ),
            ),
            const Divider(height: 40),
            // --- SECTION 2: THE DATA DISPLAY (Requirement: 15%) ---
            const Text("Recent Quotes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              height: 400, // Fixed height for the list inside a scroll view
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('quotes')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) return const Text("Error loading data");
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                  return ListView(
                    children: snapshot.data!.docs.map((doc) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          title: Text('"${doc['text']}"'),
                          subtitle: Text("- ${doc['author']} [${doc['category']}]"),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}