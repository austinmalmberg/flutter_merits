import '../application_error.dart';
import '../data/licensure_details.dart';
import '../data/licensure_summary.dart';

/// The service responsible for making [LicensureSummary]-related data requests.
abstract class LicensureService {
  LicensureService();

  Future<List<LicensureSummary>> fetchOverviewList();

  Future<LicensureDetails> getLicensureDetailsById(int id);

  /// Saves [details] to the database.
  ///
  /// On success, updates new records with their id and sets isModified to false.
  ///
  /// Throws a [LicensureTypeRequiredException] when [details.licensureType] is null.
  /// Throws a [PersonRequiredException] when [details.person] is null.
  Future<bool> saveLicensureDetails(LicensureDetails details);
}

abstract class DataException extends ApplicationException {
  DataException({required super.message});
}

class LicensureTypeRequiredException extends DataException {
  LicensureTypeRequiredException() : super(message: 'Licensure Type required.');
}

class PersonRequiredException extends DataException {
  PersonRequiredException() : super(message: 'Person required.');
}
