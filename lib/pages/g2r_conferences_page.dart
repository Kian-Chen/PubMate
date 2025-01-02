import 'package:flutter/material.dart';
import '../api/db_service.dart';
import '../models/ranking_models.dart';

class G2RConferencesPage extends StatefulWidget {
  const G2RConferencesPage({super.key});

  @override
  State<G2RConferencesPage> createState() => _G2RConferencesPageState();
}

class _G2RConferencesPageState extends State<G2RConferencesPage> {
  final DBService _dbService = DBService();

  late Future<List<G2RConferenceRanking>> _futureG2RConferenceRankings;
  List<G2RConferenceRanking> _filteredRankings = [];
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _futureG2RConferenceRankings = _dbService.getG2RConferenceRankings();
  }

  // 筛选会议
  void _filterConferences(String query) {
    setState(() {
      _searchQuery = query;
      _filteredRankings = _filteredRankings.where((ranking) {

        return ranking.conferenceName.toLowerCase().contains(query.toLowerCase()) ||
            (ranking.shortName != null && ranking.shortName!.toLowerCase().contains(query.toLowerCase()));
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conferences Ranking'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) {
                _filterConferences(query);
              },
              decoration: InputDecoration(
                labelText: 'Search Conferences',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<G2RConferenceRanking>>(
              future: _futureG2RConferenceRankings,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No G2R Conference Ranking Data Found.'));
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
                        title: Text(ranking.conferenceName),
                        subtitle: Text(
                          'Short Name: ${ranking.shortName ?? 'N/A'}\n'
                              'Ranking Position: ${ranking.rankingPosition}\n'
                              'Score: ${ranking.score}',
                        ),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/conference_details',
                            arguments: {'abbr': ranking.shortName},
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
