import 'package:flutter/material.dart';

class ConferenceDeadlinesPage extends StatelessWidget {
  const ConferenceDeadlinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Example list of deadlines; in a real app, this might come from a database
    final List<Map<String, dynamic>> deadlines = [
      {'name': 'Conference A', 'id': 256},
      {'name': 'Conference B', 'id': 257},
      // Add more conferences as needed
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conference Deadlines'),
      ),
      body: ListView.builder(
        itemCount: deadlines.length,
        itemBuilder: (context, index) {
          final conference = deadlines[index];
          return ListTile(
            title: Text(conference['name']),
            trailing: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/conference_details',
                  arguments: {'id': conference['id']},
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
