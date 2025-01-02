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
  List<JournalInfo> _filteredJournals = [];
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _futureAllJournalInfo = _dbService.getAllJournalInfo();
  }

  void _filterJournals(String query) {
    setState(() {
      _searchQuery = query;
      _filteredJournals = _filteredJournals.where((journal) {
        return journal.name.toLowerCase().contains(query.toLowerCase()) ||
            (journal.issn != null && journal.issn!.toLowerCase().contains(query.toLowerCase()));
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journals'),
      ),
      body: Column(
        children: [
          // Add the search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) {
                _filterJournals(query);
              },
              decoration: InputDecoration(
                labelText: 'Search Journals',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          // Display the journals list based on filtered results
          Expanded(
            child: FutureBuilder<List<JournalInfo>>(
              future: _futureAllJournalInfo,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator()),
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
                  // If no search query is present, display all journals
                  if (_searchQuery.isEmpty) {
                    _filteredJournals = journals;
                  }
                  return ListView.builder(
                    itemCount: _filteredJournals.length,
                    itemBuilder: (context, index) {
                      final journal = _filteredJournals[index];
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
          ),
        ],
      ),
    );
  }
}
