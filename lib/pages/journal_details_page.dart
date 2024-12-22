import 'package:flutter/material.dart';

class JournalDetailsPage extends StatelessWidget {
  final int id;

  const JournalDetailsPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    // Fetch journal details based on the ID
    // For demonstration, we'll use placeholder data
    final Map<int, String> journalDetails = {
      512: 'Details for Journal X',
      513: 'Details for Journal Y',
      // Add more details as needed
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          journalDetails[id] ?? 'No details available for this journal.',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
