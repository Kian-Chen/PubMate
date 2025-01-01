// lib/models/conference_models.dart

class ConferenceDeadlineInfo {
  final int conferenceId;
  final String conferenceName;
  final String? shortName;
  final String? link;
  final String? place;
  final String? timezone;
  final DateTime? startDate;
  final DateTime? endDate;
  final int year;
  final int? accepted;
  final int? submitted;
  final double? rate;
  final String? rateDescription;
  final String? rateSource;
  final String? ccfRating;
  final String? thCplRating;
  final String? coreRating;
  final String? subfield;
  final String? deadlineType;
  final DateTime? deadlineTime;
  final String? deadlineComment;

  ConferenceDeadlineInfo({
    required this.conferenceId,
    required this.conferenceName,
    this.shortName,
    this.link,
    this.place,
    this.timezone,
    this.startDate,
    this.endDate,
    required this.year,
    this.accepted,
    this.submitted,
    this.rate,
    this.rateDescription,
    this.rateSource,
    this.ccfRating,
    this.thCplRating,
    this.coreRating,
    this.subfield,
    this.deadlineType,
    this.deadlineTime,
    this.deadlineComment,
  });

  factory ConferenceDeadlineInfo.fromJson(Map<String, dynamic> json) {
    return ConferenceDeadlineInfo(
      conferenceId: json['conference_id'],
      conferenceName: json['conference_name'],
      shortName: json['short_name'],
      link: json['link'],
      place: json['place'],
      timezone: json['timezone'],
      startDate: json['start_date'] != null ? DateTime.parse(json['start_date']) : null,
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      year: json['year'],
      accepted: json['accepted'],
      submitted: json['submitted'],
      rate: json['rate'] != null ? (json['rate'] as num).toDouble() : null,
      rateDescription: json['rate_description'],
      rateSource: json['rate_source'],
      ccfRating: json['ccf_rating'],
      thCplRating: json['th_cpl_rating'],
      coreRating: json['core_rating'],
      subfield: json['subfield'],
      deadlineType: json['deadline_type'],
      deadlineTime: json['deadline_time'] != null ? DateTime.parse(json['deadline_time']) : null,
      deadlineComment: json['deadline_comment'],
    );
  }
}

class ConferenceDetail {
  final int conferenceId;
  final String? shortName;
  final String fullName;
  final String? ccfRating;
  final String? thCplRating;
  final String? coreRating;
  final int? year;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? place;
  final String? link;
  final String? subfield;
  final int? accepted;
  final int? submitted;
  final double? rate;
  final String? rateDescription;
  final String? rateSource;
  final String? deadlineType;
  final DateTime? deadlineTime;
  final String? deadlineComment;

  ConferenceDetail({
    required this.conferenceId,
    this.shortName,
    required this.fullName,
    this.ccfRating,
    this.thCplRating,
    this.coreRating,
    this.year,
    this.startDate,
    this.endDate,
    this.place,
    this.link,
    this.subfield,
    this.accepted,
    this.submitted,
    this.rate,
    this.rateDescription,
    this.rateSource,
    this.deadlineType,
    this.deadlineTime,
    this.deadlineComment,
  });

  factory ConferenceDetail.fromJson(Map<String, dynamic> json) {
    return ConferenceDetail(
      conferenceId: json['conference_id'],
      shortName: json['short_name'],
      fullName: json['full_name'],
      ccfRating: json['ccf_rating'],
      thCplRating: json['th_cpl_rating'],
      coreRating: json['core_rating'],
      year: json['year'],
      startDate: json['start_date'] != null ? DateTime.parse(json['start_date']) : null,
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      place: json['place'],
      link: json['link'],
      subfield: json['subfield'],
      accepted: json['accepted'],
      submitted: json['submitted'],
      rate: json['rate'] != null ? (json['rate'] as num).toDouble() : null,
      rateDescription: json['rate_description'],
      rateSource: json['rate_source'],
      deadlineType: json['deadline_type'],
      deadlineTime: json['deadline_time'] != null ? DateTime.parse(json['deadline_time']) : null,
      deadlineComment: json['deadline_comment'],
    );
  }
}

class ConferenceYearInfo {
  final String conferenceName;
  final int conferenceId;
  final String? shortName;
  final String? link;
  final String? subfield;
  final String? timezone;
  final String? ccfRating;
  final String? thCplRating;
  final String? coreRating;
  final List<ConferenceYear> years;
  final List<Deadline> deadlines;

  ConferenceYearInfo({
    required this.conferenceName,
    required this.conferenceId,
    this.shortName,
    this.link,
    this.subfield,
    this.timezone,
    this.ccfRating,
    this.thCplRating,
    this.coreRating,
    required this.years,
    required this.deadlines,
  });
}

class ConferenceDetailInfo {
  final int conferenceId;
  final String? shortName;
  final String fullName;
  final String? ccfRating;
  final String? thCplRating;
  final String? coreRating;
  final String? subfield;
  final List<YearlyConferenceInfo> yearlyInfo;

  ConferenceDetailInfo({
    required this.conferenceId,
    this.shortName,
    required this.fullName,
    this.ccfRating,
    this.thCplRating,
    this.coreRating,
    this.subfield,
    required this.yearlyInfo,
  });
}

class ConferenceYear {
  final int? year; // 改为可空
  final DateTime? startDate;
  final DateTime? endDate;
  final String? place;
  final int? accepted;
  final int? submitted;
  final double? rate;
  final String? rateDescription;
  final String? rateSource;

  ConferenceYear({
    this.year,
    this.startDate,
    this.endDate,
    this.place,
    this.accepted,
    this.submitted,
    this.rate,
    this.rateDescription,
    this.rateSource,
  });
}

class YearlyConferenceInfo {
  final int? year;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? place;
  final int? accepted;
  final int? submitted;
  final double? rate;
  final String? rateDescription;
  final String? rateSource;
  final List<Deadline> deadlines;

  YearlyConferenceInfo({
    this.year,
    this.startDate,
    this.endDate,
    this.place,
    this.accepted,
    this.submitted,
    this.rate,
    this.rateDescription,
    this.rateSource,
    required this.deadlines,
  });
}

class Deadline {
  final String? type;
  final DateTime? time;
  final String? comment;

  Deadline({
    this.type,
    this.time,
    this.comment,
  });
}

/// Helper class to group conference data
class ConferenceGroup {
  final int conferenceId;
  final String conferenceName;
  final String? shortName;
  final String? link;
  final String? subfield;
  final String? ccfRating;
  final String? thCplRating;
  final String? coreRating;
  final String? timezone;
  final List<Deadline> deadlines;
  final List<ConferenceYear> years;

  ConferenceGroup({
    required this.conferenceId,
    required this.conferenceName,
    this.shortName,
    this.link,
    this.subfield,
    this.ccfRating,
    this.thCplRating,
    this.coreRating,
    this.timezone,
    required this.deadlines,
    required this.years,
  });

  ConferenceYearInfo toConferenceYearInfo() {
    return ConferenceYearInfo(
      conferenceName: conferenceName,
      conferenceId: conferenceId,
      shortName: shortName,
      link: link,
      subfield: subfield,
      timezone: timezone,
      ccfRating: ccfRating,
      thCplRating: thCplRating,
      coreRating: coreRating,
      years: years,
      deadlines: deadlines,
    );
  }
}
