import 'dart:math';

import '../data/licensure_details.dart';
import '../data/licensure_summary.dart';
import 'test_data.dart';
import '../services/licensure_service.dart';

class TestLicensureService implements LicensureService {
  const TestLicensureService() : super();

  @override
  Future<List<LicensureSummary>> fetchOverviewList() async {
    await Future.delayed(const Duration(milliseconds: 400));

    return licensureSummaries;
  }

  @override
  Future<LicensureDetails> getLicensureDetailsById(int id) async {
    await Future.delayed(const Duration(milliseconds: 400));

    return fromSummary(licensureSummaries.firstWhere((summary) => summary.id == id));
  }

  /// Saves the given [details].
  ///
  /// On success, updates new records with their id and sets isModified to false.
  ///
  /// Throws a [LicensureTypeRequiredException] when [details.licensureType] is null.
  /// Throws a [PersonRequiredException] when [details.person] is null.
  @override
  Future<bool> saveLicensureDetails(LicensureDetails details) async {
    if (details.person == null) throw PersonRequiredException();
    if (details.licensureType == null) throw LicensureTypeRequiredException();

    if (details.isNewRecord) details.id = Random().nextInt(10000000);
    details.save();

    return true;
  }
}
