// lib/models/ranking_models.dart

class G2RConferenceRanking {
  final int rankingId;
  final int conferenceId;
  final String conferenceName;
  final String? shortName;
  final int rankingPosition;
  final double score;

  G2RConferenceRanking({
    required this.rankingId,
    required this.conferenceId,
    required this.conferenceName,
    this.shortName,
    required this.rankingPosition,
    required this.score,
  });

  factory G2RConferenceRanking.fromJson(Map<String, dynamic> json) {
    return G2RConferenceRanking(
      rankingId: json['ranking_id'],
      conferenceId: json['conference_id'],
      conferenceName: json['conference_name'],
      shortName: json['short_name'],
      rankingPosition: json['ranking_position'],
      score: (json['score'] as num).toDouble(),
    );
  }
}

class G2RJournalRanking {
  final int rankingId;
  final int journalId;
  final String journalName;
  final String? issn;
  final int rankingPosition;
  final double score;

  G2RJournalRanking({
    required this.rankingId,
    required this.journalId,
    required this.journalName,
    this.issn,
    required this.rankingPosition,
    required this.score,
  });

  factory G2RJournalRanking.fromJson(Map<String, dynamic> json) {
    return G2RJournalRanking(
      rankingId: json['ranking_id'],
      journalId: json['journal_id'],
      journalName: json['journal_name'],
      issn: json['issn'],
      rankingPosition: json['ranking_position'],
      score: (json['score'] as num).toDouble(),
    );
  }
}
