// lib/pages/conference_details_page.dart

import 'package:flutter/material.dart';
import '../api/db_service.dart';
import '../models/conference_models.dart';
import '../extensions/date_extensions.dart';

class ConferenceDetailsPage extends StatefulWidget {
  final String abbr;

  const ConferenceDetailsPage({super.key, required this.abbr});

  @override
  State<ConferenceDetailsPage> createState() => _ConferenceDetailsPageState();
}

class _ConferenceDetailsPageState extends State<ConferenceDetailsPage> {
  final DBService _dbService = DBService();
  late Future<ConferenceDetailInfo> _futureConferenceDetail;

  @override
  void initState() {
    super.initState();
    _futureConferenceDetail = _dbService.getConferenceDetailByShortName(widget.abbr);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conference Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<ConferenceDetailInfo>(
              future: _futureConferenceDetail,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('No Conference Detail Data Found.'));
                } else {
                  final detail = snapshot.data!;
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Full Name: ${detail.fullName}',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                              'Short Name: ${detail.shortName ?? 'N/A'}',
                              style: const TextStyle(fontSize: 14)
                          ),
                          Text(
                            'Ratings: CCF=${detail.ccfRating ?? 'N/A'}, '
                                'TH-CPL=${detail.thCplRating ?? 'N/A'}, '
                                'CORE=${detail.coreRating ?? 'N/A'}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                              'Subfield: ${detail.subfield ?? 'N/A'}',
                              style: const TextStyle(fontSize: 14)
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Yearly Information:',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          ...detail.yearlyInfo.map((yearInfo) => ListTile(
                            title: Text('Year: ${yearInfo.year ?? 'N/A'}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Dates: ${yearInfo.startDate?.toShortDateString() ?? 'N/A'} - ${yearInfo.endDate?.toShortDateString() ?? 'N/A'}'),
                                Text('Place: ${yearInfo.place ?? 'N/A'}'),
                                Text('Acceptance Rate: ${yearInfo.rate ?? 'N/A'}%'),
                                Text('Rate Description: ${yearInfo.rateDescription ?? 'N/A'}'),
                                Text('Rate Source: ${yearInfo.rateSource ?? 'N/A'}'),
                                const SizedBox(height: 5),
                                const Text('Deadlines:'),
                                ...yearInfo.deadlines.map((ddl) => Padding(
                                  padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                                  child: Text(
                                    '${ddl.type ?? 'N/A'} at ${ddl.time != null ? ddl.time!.toReadableString() : 'N/A'}\nComment: ${ddl.comment ?? 'N/A'}',
                                  ),
                                )),
                              ],
                            ),
                            isThreeLine: true,
                          )),
                        ],
                      ),
                    ),
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
