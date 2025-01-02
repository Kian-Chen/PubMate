// lib/api/db_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/conference_models.dart';
import '../models/journal_models.dart';
import '../models/ranking_models.dart';

class DBService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// 1. 获取会议Deadline信息
  /// 返回一个list，每个元素包含某一年的会议信息及其相关数据
  Future<List<ConferenceYearInfo>> getConferenceDeadlineInfo() async {
    final response = await _supabase
        .from('view_conference_deadline_info')
        .select(
        'conference_id, conference_name, short_name, link, place, timezone, start_date, end_date, year, accepted, submitted, rate, rate_description, rate_source, ccf_rating, th_cpl_rating, core_rating, subfield, deadline_type, deadline_time, deadline_comment')
        .order('conference_id', ascending: true);

    if (response == null) {
      throw Exception('Error in getConferenceDeadlineInfo: $response');
    }

    // Map to a list of ConferenceDeadlineInfo
    final data = (response as List)
        .map((json) => ConferenceDeadlineInfo.fromJson(json))
        .toList();

    // Organize data into a list where each element is a year's conference info
    // For each conference, group by conference_id
    Map<int, ConferenceGroup> conferenceMap = {};

    for (var info in data) {
      if (!conferenceMap.containsKey(info.conferenceId)) {
        conferenceMap[info.conferenceId] = ConferenceGroup(
          conferenceId: info.conferenceId,
          conferenceName: info.conferenceName,
          shortName: info.shortName,
          link: info.link,
          subfield: info.subfield,
          ccfRating: info.ccfRating,
          thCplRating: info.thCplRating,
          coreRating: info.coreRating,
          timezone: info.timezone,
          deadlines: [],
          years: [],
        );
      }

      ConferenceGroup group = conferenceMap[info.conferenceId]!;

      // Add year info
      ConferenceYear yearInfo = ConferenceYear(
        year: info.year,
        startDate: info.startDate,
        endDate: info.endDate,
        place: info.place,
        accepted: info.accepted,
        submitted: info.submitted,
        rate: info.rate,
        rateDescription: info.rateDescription,
        rateSource: info.rateSource,
      );
      group.years.add(yearInfo);

      // Add deadline info
      Deadline deadline = Deadline(
        type: info.deadlineType,
        time: info.deadlineTime,
        comment: info.deadlineComment,
      );
      group.deadlines.add(deadline);
    }

    // Convert map to list
    return conferenceMap.values.map((group) => group.toConferenceYearInfo()).toList();
  }

  /// 2. 获取特定会议的详细信息
  /// 返回一个字典，包含会议的评级信息和每年的详细信息
  Future<ConferenceDetailInfo> getConferenceDetailByShortName(String shortName) async {
    final response = await _supabase
        .from('view_conference_detail')
        .select(
        'conference_id, short_name, full_name, ccf_rating, th_cpl_rating, core_rating, year, start_date, end_date, place, link, subfield, accepted, submitted, rate, rate_description, rate_source, deadline_type, deadline_time, deadline_comment')
        .eq('short_name', shortName)
        .order('year', ascending: false);

    if (response == null) {
      throw Exception('Error in getConferenceDetailByShortName: $response');
    }

    final data = (response as List)
        .map((json) => ConferenceDetail.fromJson(json))
        .toList();

    if (data.isEmpty) {
      throw Exception('Conference not found');
    }

    // Assuming all records have the same conference info
    final first = data.first;

    ConferenceDetailInfo detailInfo = ConferenceDetailInfo(
      conferenceId: first.conferenceId,
      shortName: first.shortName,
      fullName: first.fullName,
      ccfRating: first.ccfRating,
      thCplRating: first.thCplRating,
      coreRating: first.coreRating,
      subfield: first.subfield,
      yearlyInfo: [],
    );

    for (var detail in data) {
      YearlyConferenceInfo yearly = YearlyConferenceInfo(
        year: detail.year,
        startDate: detail.startDate,
        endDate: detail.endDate,
        place: detail.place,
        accepted: detail.accepted,
        submitted: detail.submitted,
        rate: detail.rate,
        rateDescription: detail.rateDescription,
        rateSource: detail.rateSource,
        deadlines: [
          Deadline(
            type: detail.deadlineType,
            time: detail.deadlineTime,
            comment: detail.deadlineComment,
          )
        ],
      );
      detailInfo.yearlyInfo.add(yearly);
    }

    return detailInfo;
  }

  /// 3. 获取Guide2Research会议排名
  /// 返回一个list，每个元素包含会议的基本排名信息
  Future<List<G2RConferenceRanking>> getG2RConferenceRankings() async {
    final response = await _supabase
        .from('view_g2r_conference_rankings')
        .select(
        'ranking_id, conference_id, conference_name, short_name, ranking_position, score')
        .order('ranking_position', ascending: true);

    if (response == null) {
      throw Exception('Error in getG2RConferenceRankings: $response');
    }

    return (response as List)
        .map((json) => G2RConferenceRanking.fromJson(json))
        .toList();
  }

  /// 4. 获取所有期刊信息
  /// 返回一个list，每个元素是一个期刊的关键信息键值对
  Future<List<JournalInfo>> getAllJournalInfo() async {
    final response = await _supabase
        .from('view_journal_info')
        .select(
        'journal_id, name, issn, url, cas_partition, cas_major_category, cas_minor_category, subfield, rating_system, rating, review_cycle, acceptance_difficulty, h_index, cite_score, jcr, impact_factor, best_scientists, documents')
        .order('journal_id', ascending: true);

    if (response == null) {
      throw Exception('Error in getAllJournalInfo: $response');
    }

    return (response as List)
        .map((json) => JournalInfo.fromJson(json))
        .toList();
  }

  /// 5. 获取特定期刊的详细信息
  /// 返回一个精确的期刊所有数据的json
  Future<Map<String, dynamic>> getJournalDetailByName(String journalName) async {
    final response = await _supabase
        .from('view_journal_detail')
        .select(
        'journal_id, journal_name, issn, url, cas_partition, cas_major_category, cas_minor_category, subfield, rating_system, rating, review_cycle, acceptance_difficulty, h_index, cite_score, jcr, impact_factor, best_scientists, documents')
        .eq('journal_name', journalName);

    if (response == null) {
      throw Exception('Error in getJournalDetailByName: $response');
    }

    final data = (response as List)
        .map((json) => JournalDetail.fromJson(json))
        .toList();

    if (data.isEmpty) {
      throw Exception('Journal not found');
    }

    final journal = data.first;

    return {
      'journal_id': journal.journalId,
      'journal_name': journal.journalName,
      'issn': journal.issn,
      'url': journal.url,
      'cas_partition': journal.casPartition,
      'cas_major_category': journal.casMajorCategory,
      'cas_minor_category': journal.casMinorCategory,
      'subfield': journal.subfield,
      'ratings': {
        'rating_system': journal.ratingSystem,
        'rating': journal.rating,
      },
      'evaluation': {
        'review_cycle': journal.reviewCycle,
        'acceptance_difficulty': journal.acceptanceDifficulty,
        'h_index': journal.hIndex,
        'cite_score': journal.citeScore,
        'jcr': journal.jcr,
        'impact_factor': journal.impactFactor,
        'best_scientists': journal.bestScientists,
        'documents': journal.documents,
      },
    };
  }

  /// 6. 获取Guide2Research期刊排名
  /// 返回一个list，每个元素包含期刊的基本排名信息
  Future<List<G2RJournalRanking>> getG2RJournalRankings() async {
    final response = await _supabase
        .from('view_g2r_journal_rankings')
        .select(
        'ranking_id, journal_id, journal_name, issn, ranking_position, score')
        .order('ranking_position', ascending: true);

    if (response == null) {
      throw Exception('Error in getG2RJournalRankings: $response');
    }

    return (response as List)
        .map((json) => G2RJournalRanking.fromJson(json))
        .toList();
  }
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
