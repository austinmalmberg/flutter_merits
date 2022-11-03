import 'activity_entry.dart';
import 'licensure_status.dart';
import 'licensure_summary.dart';

class LicensureDetails extends LicensureSummary {
  LicensureDetails({
    required super.id,
    required super.status,
    super.licensureType,
    super.person,
    super.lastVerified,
    super.listingNumber,
    super.expiration,
    DateTime? issueDate,
    String comment = '',
    this.activityLog = const [],
  })  : _issueDate = issueDate,
        _comment = comment;

  factory LicensureDetails.fromSummary(
    LicensureSummary summary, {
    DateTime? issueDate,
    String comments = '',
    List<ActivityEntry> activityLog = const [],
  }) =>
      LicensureDetails(
        id: summary.id,
        licensureType: summary.licensureType,
        status: summary.status,
        person: summary.person,
        listingNumber: summary.listingNumber,
        expiration: summary.expiration,
        lastVerified: summary.lastVerified,
        issueDate: issueDate,
        comment: comments,
        activityLog: activityLog,
      );

  factory LicensureDetails.newRecord() => LicensureDetails(
        id: 0,
        status: LicensureStatus.pending,
      );

  String _comment;
  String get comment => _comment;
  set comment(String value) {
    if (_comment != value) {
      _comment = value;
      isModified = true;

      notifyListeners();
    }
  }

  DateTime? _issueDate;
  DateTime? get issueDate => _issueDate;
  set issueDate(DateTime? value) {
    if (_issueDate != value) {
      _issueDate = value;
      isModified = true;

      notifyListeners();
    }
  }

  final List<ActivityEntry> activityLog;
}
