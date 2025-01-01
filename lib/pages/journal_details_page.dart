import 'package:flutter/material.dart';
import '../api/db_service.dart';

class JournalDetailsPage extends StatefulWidget {
  final String name;

  const JournalDetailsPage({super.key, required this.name});

  @override
  State<JournalDetailsPage> createState() => _JournalDetailsPageState();
}

class _JournalDetailsPageState extends State<JournalDetailsPage> {
  final DBService _dbService = DBService();

  late Future<Map<String, dynamic>> _futureJournalDetail;

  @override
  void initState() {
    super.initState();
    // 在初始化时获取期刊详情
    _futureJournalDetail = _dbService.getJournalDetailByName(widget.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal Details'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _futureJournalDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text('Error: ${snapshot.error}')),
            );
          } else if (!snapshot.hasData) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: Text('No Journal Data Found.')),
            );
          } else {
            final journal = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Journal Name: ${journal['journal_name']}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                          'ISSN: ${journal['issn'] ?? 'N/A'}',
                          style: const TextStyle(fontSize: 14)
                      ),
                      Text(
                          'URL: ${journal['url'] ?? 'N/A'}',
                          style: const TextStyle(fontSize: 14)
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'CAS Information:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                          'Partition: ${journal['cas_partition'] ?? 'N/A'}',
                          style: const TextStyle(fontSize: 14)
                      ),
                      Text(
                          'Major Category: ${journal['cas_major_category'] ?? 'N/A'}',
                          style: const TextStyle(fontSize: 14)
                      ),
                      Text(
                          'Minor Category: ${journal['cas_minor_category'] ?? 'N/A'}',
                          style: const TextStyle(fontSize: 14)
                      ),
                      const SizedBox(height: 10),
                      Text(
                          'Subfield: ${journal['subfield'] ?? 'N/A'}',
                          style: const TextStyle(fontSize: 14)
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Ratings:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Rating System: ${journal['ratings']['rating_system'] ?? 'N/A'}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Rating: ${journal['ratings']['rating'] ?? 'N/A'}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Evaluation:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Review Cycle: ${journal['evaluation']['review_cycle'] ?? 'N/A'}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Acceptance Difficulty: ${journal['evaluation']['acceptance_difficulty'] ?? 'N/A'}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        'H-Index: ${journal['evaluation']['h_index']?.toString() ?? 'N/A'}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        'CiteScore: ${journal['evaluation']['cite_score']?.toString() ?? 'N/A'}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        'JCR: ${journal['evaluation']['jcr'] ?? 'N/A'}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Impact Factor: ${journal['evaluation']['impact_factor']?.toString() ?? 'N/A'}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Best Scientists: ${journal['evaluation']['best_scientists']?.toString() ?? 'N/A'}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Documents: ${journal['evaluation']['documents']?.toString() ?? 'N/A'}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
