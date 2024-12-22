import 'package:flutter/material.dart';

class ConferenceDetailsPage extends StatelessWidget {
  final int id;

  const ConferenceDetailsPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    // Fetch conference details based on the ID
    // For demonstration, we'll use placeholder data
    final Map<int, String> conferenceDetails = {
      256: 'Details for Conference A',
      257: 'Details for Conference B',
      // Add more details as needed
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conference Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          conferenceDetails[id] ?? 'No details available for this conference.',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
