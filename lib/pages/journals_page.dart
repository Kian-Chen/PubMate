import 'package:flutter/material.dart';

class JournalsPage extends StatelessWidget {
  const JournalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Example list of journals; in a real app, this might come from a database
    final List<Map<String, dynamic>> journals = [
      {'name': 'Journal X', 'id': 512},
      {'name': 'Journal Y', 'id': 513},
      // Add more journals as needed
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Journals'),
      ),
      body: ListView.builder(
        itemCount: journals.length,
        itemBuilder: (context, index) {
          final journal = journals[index];
          return ListTile(
            title: Text(journal['name']),
            trailing: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/journal_details',
                  arguments: {'id': journal['id']},
                );
              },
              child: const Text('Details'),
            ),
          );
        },
      ),
    );
  }
}
