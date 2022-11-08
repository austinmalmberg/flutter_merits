import 'package:flutter/material.dart';

import '_modification_mixin.dart';
import 'licensure_status.dart';
import 'licensure_type.dart';
import 'person.dart';

class LicensureSummary extends ChangeNotifier with ModificationMixin {
  LicensureSummary({
    required int id,
    required LicensureStatus status,
    LicensureType? licensureType,
    Person? person,
    String listingNumber = '',
    DateTime? expiration,
    DateTime? lastVerified,
  })  : _id = id,
        _status = status,
        _licensureType = licensureType,
        _person = person,
        _listingNumber = listingNumber,
        _expiration = expiration,
        _lastVerified = lastVerified;

  int _id;

  /// The licensure id.
  int get id => _id;
  set id(int value) {
    if (_id != value) {
      _id = value;
      _isModified = true;

      notifyListeners();
    }
  }

  Person? _person;

  /// The licensure or certification holder.
  Person? get person => _person;
  set person(Person? value) {
    if (_person != value) {
      _person = value;
      _isModified = true;

      notifyListeners();
    }
  }

  LicensureType? _licensureType;

  /// The licensure type.
  LicensureType? get licensureType => _licensureType;
  set licensureType(LicensureType? value) {
    if (_licensureType != value) {
      _licensureType = value;
      _isModified = true;

      notifyListeners();
    }
  }

  LicensureStatus _status;

  /// The licensure status.
  LicensureStatus get status => _status;
  set status(LicensureStatus value) {
    if (_status != value) {
      _status = value;
      _isModified = true;

      notifyListeners();
    }
  }

  String _listingNumber;

  /// The listing number given to each licensure.
  String get listingNumber => _listingNumber;
  set listingNumber(String value) {
    if (_listingNumber != value) {
      _listingNumber = value;
      _isModified = true;

      notifyListeners();
    }
  }

  DateTime? _expiration;

  /// The date the licensure is set to expire.
  DateTime? get expiration => _expiration;
  set expiration(DateTime? value) {
    if (_expiration != value) {
      _expiration = value;
      _isModified = true;

      notifyListeners();
    }
  }

  DateTime? _lastVerified;

  /// The date that the licensure was last verified.
  ///
  /// Licensures can be verified in the following ways:
  /// - When the licensure is created
  /// - By clicking the verify button
  DateTime? get lastVerified => _lastVerified;
  set lastVerified(DateTime? value) {
    if (_lastVerified != value) {
      _lastVerified = value;
      _isModified = true;

      notifyListeners();
    }
  }

  /// Returns [LicensureStatus.expired] when the [status] is [LicensureStatus.active] and the [expiration] has passed.
  LicensureStatus get runtimeStatus {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day).subtract(const Duration(milliseconds: 1));
    if (status != LicensureStatus.active || expiration == null || expiration!.isAfter(today)) return status;

    return LicensureStatus.expired;
  }

  bool _isModified = false;

  @override // ModificationMixin
  bool get isModified => _isModified;

  @override
  set isModified(bool value) {
    if (_isModified != value) {
      _isModified = value;

      notifyListeners();
    }
  }

  /// Sets [isModified] to false.
  void save() {
    if (_isModified) {
      _isModified = false;

      notifyListeners();
    }
  }

  /// Returns the amount of time remaining or null when [expiration] is null.
  Duration? get remaining => expiration?.difference(DateTime.now());

  bool get isNewRecord => id <= 0;

  factory LicensureSummary.fromJson(Map<String, dynamic> json) {
    String? expirationStr = json['expiration'];
    String? lastVerifiedStr = json['lastVerified'];
    String? licensureTypeStr = json['licensureType'];

    LicensureType? licensureType;
    if (licensureTypeStr != null) {
      for (LicensureType type in LicensureType.values) {
        if (type.toString().toLowerCase() == licensureTypeStr.toLowerCase()) {
          licensureType = type;
          break;
        }
      }
    }

    return LicensureSummary(
      id: json['id'],
      status: LicensureStatus.values
          .firstWhere((status) => status.toString().toLowerCase() == json['status'].toString().toLowerCase()),
      expiration: expirationStr == null ? null : DateTime.parse(expirationStr),
      lastVerified: lastVerifiedStr == null ? null : DateTime.parse(lastVerifiedStr),
      licensureType: licensureType,
      listingNumber: json['listingNumber'] ?? '',
      person: Person.fromJson(json['person']),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'status': status.toString(),
        'expiration': expiration?.toIso8601String(),
        'lastVerified': lastVerified?.toIso8601String(),
        'licensureType': licensureType?.toString(),
        'listingNumber': listingNumber,
        'person': person?.toJson(),
      };

  @override
  bool operator ==(Object other) {
    if (other is! LicensureSummary) return false;

    return id == other.id &&
        status == other.status &&
        licensureType == other.licensureType &&
        person == other.person &&
        listingNumber == other.listingNumber &&
        expiration == other.expiration &&
        lastVerified == other.lastVerified;
  }

  @override
  int get hashCode => super.hashCode;
}
