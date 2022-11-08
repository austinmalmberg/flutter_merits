import 'activity_entry.dart';
import 'licensure_status.dart';
import 'licensure_summary.dart';
import 'licensure_type.dart';
import 'person.dart';

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
    String comment = '',
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
        comment: comment,
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

  factory LicensureDetails.fromJson(Map<String, dynamic> json) {
    String? expirationStr = json['expiration'];
    String? lastVerifiedStr = json['lastVerified'];
    String? issueDateStr = json['issueDate'];
    String? licensureTypeStr = json['licensureType'];
    Map<String, dynamic>? person = json['person'];

    LicensureType? licensureType;
    if (licensureTypeStr != null) {
      for (LicensureType type in LicensureType.values) {
        if (type.toString().toLowerCase() == licensureTypeStr.toLowerCase()) {
          licensureType = type;
          break;
        }
      }
    }
    LicensureStatus licensureStatus = LicensureStatus.values
        .firstWhere((element) => element.toString().toLowerCase() == json['status'].toString().toLowerCase());

    List<dynamic>? activityLogList = json['activityLog'];
    final List<ActivityEntry> activityLog = activityLogList == null
        ? <ActivityEntry>[]
        : activityLogList.map((entry) => ActivityEntry.fromJson(entry)).toList();

    return LicensureDetails(
      id: json['id'],
      status: licensureStatus,
      expiration: expirationStr == null ? null : DateTime.parse(expirationStr),
      lastVerified: lastVerifiedStr == null ? null : DateTime.parse(lastVerifiedStr),
      licensureType: licensureType,
      listingNumber: json['listingNumber'] ?? '',
      person: person == null ? null : Person.fromJson(person),
      activityLog: activityLog,
      issueDate: issueDateStr == null ? null : DateTime.parse(issueDateStr),
      comment: json['comment'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'status': status.toString(),
        'expiration': expiration?.toIso8601String(),
        'lastVerified': lastVerified?.toIso8601String(),
        'licensureType': licensureType?.toString(),
        'listingNumber': listingNumber,
        'person': person?.toJson(),
        'acivityLog': activityLog.map((entry) => entry.toJson()).toList(),
        'issueDate': issueDate?.toIso8601String(),
        'comment': comment,
      };

  @override
  bool operator ==(Object other) {
    if (other is! LicensureDetails) return false;

    return id == other.id &&
        status == other.status &&
        expiration == other.expiration &&
        lastVerified == other.lastVerified &&
        licensureType == other.licensureType &&
        listingNumber == other.listingNumber &&
        person == other.person &&
        issueDate == other.issueDate &&
        comment == other.comment;
  }

  @override
  int get hashCode => super.hashCode;
}
