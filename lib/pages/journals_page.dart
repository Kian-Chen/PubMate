import 'package:flutter/material.dart';
import '../api/db_service.dart';
import '../models/journal_models.dart';

class JournalsPage extends StatefulWidget {
  const JournalsPage({super.key});

  @override
  State<JournalsPage> createState() => _JournalsPageState();
}

class _JournalsPageState extends State<JournalsPage> {
  final DBService _dbService = DBService();

  late Future<List<JournalInfo>> _futureAllJournalInfo;

  @override
  void initState() {
    super.initState();
    _futureAllJournalInfo = _dbService.getAllJournalInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journals'),
      ),
      body: FutureBuilder<List<JournalInfo>>(
        future: _futureAllJournalInfo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('No Journal Data Found.'),
            );
          } else {
            final journals = snapshot.data!;
            return ListView.builder(
              itemCount: journals.length,
              itemBuilder: (context, index) {
                final journal = journals[index];
                return ListTile(
                  title: Text(journal.name),
                  subtitle: Text('ISSN: ${journal.issn ?? 'N/A'}'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/journal_details',
                        arguments: {'name': journal.name},
                      );
                    },
                    child: const Text('Details'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
