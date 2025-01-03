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
  List<ConferenceYearInfo> _filteredConferences = [];
  String _searchQuery = "";
  Set<String> _selectedSubfields = {}; // Set to hold selected subfields
  String _selectedEvaluation = 'CCF'; // Default selected evaluation filter
  Set<String> _selectedRatings = {}; // Set to hold selected ratings

  final List<String> subfields = ["All", "AI", "CG", "CT", "DB", "DS", "HI", "MX", "NW", "SC", "SE"];
  final List<String> evaluationOptions = ["CCF", "TH-CPL", "CORE"];
  final Map<String, List<String>> ratingOptions = {
    'CCF': ['A', 'B', 'C', 'N'],
    'TH-CPL': ['A', 'B', 'N'],
    'CORE': ['A*', 'A', 'B', 'C', 'N'],
  };

  @override
  void initState() {
    super.initState();
    _futureConferenceDeadlineInfo = _dbService.getConferenceDeadlineInfo();
  }

  void _filterConferences(String query) {
    setState(() {
      _searchQuery = query;
      // Filter conferences based on search query, selected subfields, and selected ratings
      _filteredConferences = _filteredConferences.where((conference) {
        bool matchesQuery = conference.conferenceName
            .toLowerCase()
            .contains(query.toLowerCase()) ||
            (conference.shortName ?? '')
                .toLowerCase()
                .contains(query.toLowerCase());

        bool matchesSubfield = _selectedSubfields.isEmpty || _selectedSubfields.contains("All") ||
            (conference.subfield != null && _selectedSubfields.contains(conference.subfield));

        bool matchesRating = _selectedRatings.isEmpty ||
            (conference.ccfRating != null && _selectedRatings.contains(conference.ccfRating)) ||
            (conference.thCplRating != null && _selectedRatings.contains(conference.thCplRating)) ||
            (conference.coreRating != null && _selectedRatings.contains(conference.coreRating));

        return matchesQuery && matchesSubfield && matchesRating;
      }).toList();
    });
  }

  void _toggleSubfield(String subfield) {
    setState(() {
      if (subfield == "All") {
        if (_selectedSubfields.contains("All")) {
          _selectedSubfields.clear();
        } else {
          var subfieldsCopy = Set.from(subfields);
          subfieldsCopy.remove("All");
          _selectedSubfields = Set.from(subfieldsCopy);
          _selectedSubfields.add("All");
        }
      } else {
        if (_selectedSubfields.contains(subfield)) {
          _selectedSubfields.remove(subfield);
        } else {
          _selectedSubfields.add(subfield);
        }
      }
      _filterConferences(_searchQuery);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conference Deadlines'),
      ),
      body: Column(
        children: [
          // Add Subfield selection buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: subfields.map((subfield) {
                  bool isSelected = _selectedSubfields.contains(subfield);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? Colors.blue : Colors.grey, // Highlight selected button
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () {
                        _toggleSubfield(subfield); // Toggle the subfield selection
                      },
                      child: Text(
                        subfield,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // Add search bar
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
          // Ratings filter based on selected evaluation method
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row to separate evaluation type (left) and ratings (right)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left side: Evaluation selection (CCF, TH-CPL, CORE)
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                      child: DropdownButton<String>(
                        value: _selectedEvaluation,
                        icon: const Icon(Icons.filter_list),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedEvaluation = newValue!;
                            _selectedRatings.clear();
                            _filterConferences(_searchQuery);
                          });
                        },
                        items: evaluationOptions.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    // Right side: Ratings filter chips
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: ratingOptions[_selectedEvaluation]!.map((rating) {
                        return InputChip(
                          label: Text(rating),
                          selected: _selectedRatings.contains(rating),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedRatings.add(rating);
                              } else {
                                _selectedRatings.remove(rating);
                              }
                              _filterConferences(_searchQuery);
                            });
                          },
                          selectedColor: Colors.blue,
                          backgroundColor: Colors.grey[300],
                          showCheckmark: false,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Display FutureBuilder with filtered conferences
          Expanded(
            child: FutureBuilder<List<ConferenceYearInfo>>(
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
                  if (_searchQuery.isEmpty && _selectedSubfields.isEmpty && _selectedRatings.isEmpty) {
                    _filteredConferences = conferences;
                  }
                  return SingleChildScrollView(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _filteredConferences.length,
                      itemBuilder: (context, index) {
                        final conference = _filteredConferences[index];
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
                    ),
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
