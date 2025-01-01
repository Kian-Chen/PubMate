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

  @override
  void initState() {
    super.initState();
    _futureG2RConferenceRankings = _dbService.getG2RConferenceRankings(); // 获取会议排名数据
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conferences Ranking'),
      ),
      body: FutureBuilder<List<G2RConferenceRanking>>(
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
            return ListView.builder(
              itemCount: rankings.length,
              itemBuilder: (context, index) {
                final ranking = rankings[index];
                return ListTile(
                  title: Text(ranking.conferenceName),
                  subtitle: Text(
                    'Short Name: ${ranking.shortName ?? 'N/A'}\n'
                        'Ranking Position: ${ranking.rankingPosition}\n'
                        'Score: ${ranking.score}',
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    // 跳转到会议详情页，并传递会议的简写作为参数
                    Navigator.pushNamed(
                      context,
                      '/conference_details', // 假设会议详情页的路由为 /conference_details
                      arguments: {'abbr': ranking.shortName},
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
