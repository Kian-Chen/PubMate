import 'package:flutter/material.dart';
import '../api/db_service.dart';
import '../models/ranking_models.dart';

class G2RJournalsPage extends StatefulWidget {
  const G2RJournalsPage({super.key});

  @override
  State<G2RJournalsPage> createState() => _G2RJournalsPageState();
}

class _G2RJournalsPageState extends State<G2RJournalsPage> {
  final DBService _dbService = DBService();

  late Future<List<G2RJournalRanking>> _futureG2RJournalRankings;
  List<G2RJournalRanking> _filteredRankings = [];
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _futureG2RJournalRankings = _dbService.getG2RJournalRankings();
  }

  void _filterJournals(String query) {
    setState(() {
      _searchQuery = query;
      _filteredRankings = _filteredRankings.where((ranking) {
        return ranking.journalName.toLowerCase().contains(query.toLowerCase()) ||
            (ranking.issn != null && ranking.issn!.toLowerCase().contains(query.toLowerCase()));
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('G2R Journal Rankings'),
      ),
      body: Column(
        children: [
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
          Expanded(
            child: FutureBuilder<List<G2RJournalRanking>>(
              future: _futureG2RJournalRankings,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No G2R Journal Ranking Data Found.'));
                } else {
                  final rankings = snapshot.data!;
                  if (_searchQuery.isEmpty) {
                    _filteredRankings = rankings;
                  }
                  return ListView.builder(
                    itemCount: _filteredRankings.length,
                    itemBuilder: (context, index) {
                      final ranking = _filteredRankings[index];
                      return ListTile(
                        title: Text(ranking.journalName),
                        subtitle: Text(
                          'ISSN: ${ranking.issn ?? 'N/A'}\n'
                              'Ranking Position: ${ranking.rankingPosition}\n'
                              'Score: ${ranking.score}',
                        ),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/journal_details',
                            arguments: {'name': ranking.journalName},
                          );
                        },
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
