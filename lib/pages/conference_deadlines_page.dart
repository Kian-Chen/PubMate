import 'package:flutter/material.dart';
import '../api/db_service.dart';
import '../models/conference_models.dart';
import '../extensions/date_extensions.dart';

class ConferenceDeadlinesPage extends StatefulWidget {
  const ConferenceDeadlinesPage({super.key});

  @override
  State<ConferenceDeadlinesPage> createState() => _ConferenceDeadlinesPageState();
}

class _ConferenceDeadlinesPageState extends State<ConferenceDeadlinesPage> {
  final DBService _dbService = DBService();
  late Future<List<ConferenceYearInfo>> _futureConferenceDeadlineInfo;

  @override
  void initState() {
    super.initState();
    _futureConferenceDeadlineInfo = _dbService.getConferenceDeadlineInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conference Deadlines'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<ConferenceYearInfo>>(
              future: _futureConferenceDeadlineInfo,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No Conference Deadline Data Found.'));
                } else {
                  final conferences = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: conferences.length,
                    itemBuilder: (context, index) {
                      final conference = conferences[index];
                      return ExpansionTile(
                        title: Text(conference.conferenceName),
                        subtitle: Text('Short Name: ${conference.shortName ?? 'N/A'}'),
                        children: conference.years.map((yearInfo) {
                          return ListTile(
                            title: Text('Year: ${yearInfo.year}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Dates: ${yearInfo.startDate?.toShortDateString() ?? 'N/A'} - ${yearInfo.endDate?.toShortDateString() ?? 'N/A'}'),
                                Text('Place: ${yearInfo.place ?? 'N/A'}'),
                                Text('Acceptance Rate: ${yearInfo.rate ?? 'N/A'}%'),
                                Text('Rate Description: ${yearInfo.rateDescription ?? 'N/A'}'),
                                Text('Rate Source: ${yearInfo.rateSource ?? 'N/A'}'),
                                const SizedBox(height: 5),
                                Text(
                                  'Ratings: CCF=${conference.ccfRating ?? 'N/A'}, '
                                      'TH-CPL=${conference.thCplRating ?? 'N/A'}, '
                                      'CORE=${conference.coreRating ?? 'N/A'}',
                                ),
                                const SizedBox(height: 5),
                                Text('Subfield: ${conference.subfield ?? 'N/A'}'),
                                const SizedBox(height: 5),
                                const Text('Deadlines:'),
                                ...conference.deadlines.map((ddl) => Padding(
                                  padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                                  child: Text(
                                    '${ddl.type ?? 'N/A'} at ${ddl.time != null ? ddl.time!.toReadableString() : 'N/A'}\nComment: ${ddl.comment ?? 'N/A'}',
                                  ),
                                )),
                              ],
                            ),
                            isThreeLine: true,
                            trailing: ElevatedButton(
                              onPressed: () {
                                // Navigate to conference details page, passing shortName
                                Navigator.pushNamed(
                                  context,
                                  '/conference_details',
                                  arguments: {'abbr': conference.shortName},
                                );
                              },
                              child: const Text('Details'),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
