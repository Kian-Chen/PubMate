// lib/models/journal_models.dart

class JournalInfo {
  final int journalId;
  final String name;
  final String? issn;
  final String? url;
  final String? casPartition;
  final String? casMajorCategory;
  final String? casMinorCategory;
  final String? subfield;
  final String? ratingSystem;
  final String? rating;
  final String? reviewCycle;
  final String? acceptanceDifficulty;
  final int? hIndex;
  final double? citeScore;
  final String? jcr;
  final double? impactFactor;
  final int? bestScientists;
  final int? documents;

  JournalInfo({
    required this.journalId,
    required this.name,
    this.issn,
    this.url,
    this.casPartition,
    this.casMajorCategory,
    this.casMinorCategory,
    this.subfield,
    this.ratingSystem,
    this.rating,
    this.reviewCycle,
    this.acceptanceDifficulty,
    this.hIndex,
    this.citeScore,
    this.jcr,
    this.impactFactor,
    this.bestScientists,
    this.documents,
  });

  factory JournalInfo.fromJson(Map<String, dynamic> json) {
    return JournalInfo(
      journalId: json['journal_id'],
      name: json['name'],
      issn: json['issn'],
      url: json['url'],
      casPartition: json['cas_partition'],
      casMajorCategory: json['cas_major_category'],
      casMinorCategory: json['cas_minor_category'],
      subfield: json['subfield'],
      ratingSystem: json['rating_system'],
      rating: json['rating'],
      reviewCycle: json['review_cycle'],
      acceptanceDifficulty: json['acceptance_difficulty'],
      hIndex: json['h_index'],
      citeScore: json['cite_score'] != null ? (json['cite_score'] as num).toDouble() : null,
      jcr: json['jcr'],
      impactFactor: json['impact_factor'] != null ? (json['impact_factor'] as num).toDouble() : null,
      bestScientists: json['best_scientists'],
      documents: json['documents'],
    );
  }
}

class JournalDetail {
  final int journalId;
  final String journalName;
  final String? issn;
  final String? url;
  final String? casPartition;
  final String? casMajorCategory;
  final String? casMinorCategory;
  final String? subfield;
  final String? ratingSystem;
  final String? rating;
  final String? reviewCycle;
  final String? acceptanceDifficulty;
  final int? hIndex;
  final double? citeScore;
  final String? jcr;
  final double? impactFactor;
  final int? bestScientists;
  final int? documents;

  JournalDetail({
    required this.journalId,
    required this.journalName,
    this.issn,
    this.url,
    this.casPartition,
    this.casMajorCategory,
    this.casMinorCategory,
    this.subfield,
    this.ratingSystem,
    this.rating,
    this.reviewCycle,
    this.acceptanceDifficulty,
    this.hIndex,
    this.citeScore,
    this.jcr,
    this.impactFactor,
    this.bestScientists,
    this.documents,
  });

  factory JournalDetail.fromJson(Map<String, dynamic> json) {
    return JournalDetail(
      journalId: json['journal_id'],
      journalName: json['journal_name'],
      issn: json['issn'],
      url: json['url'],
      casPartition: json['cas_partition'],
      casMajorCategory: json['cas_major_category'],
      casMinorCategory: json['cas_minor_category'],
      subfield: json['subfield'],
      ratingSystem: json['rating_system'],
      rating: json['rating'],
      reviewCycle: json['review_cycle'],
      acceptanceDifficulty: json['acceptance_difficulty'],
      hIndex: json['h_index'],
      citeScore: json['cite_score'] != null ? (json['cite_score'] as num).toDouble() : null,
      jcr: json['jcr'],
      impactFactor: json['impact_factor'] != null ? (json['impact_factor'] as num).toDouble() : null,
      bestScientists: json['best_scientists'],
      documents: json['documents'],
    );
  }
}
