// lib/pages/G2RJournalsPage.dart

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

  @override
  void initState() {
    super.initState();

    _futureG2RJournalRankings = _dbService.getG2RJournalRankings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('G2R Journal Rankings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<G2RJournalRanking>>(
              future: _futureG2RJournalRankings,
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
                    child: Text('No G2R Journal Ranking Data Found.'),
                  );
                } else {
                  final rankings = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: rankings.length,
                    itemBuilder: (context, index) {
                      final ranking = rankings[index];
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
