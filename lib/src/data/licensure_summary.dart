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
}

abstract class LicensureSummarySorting {
  static int Function(LicensureSummary, LicensureSummary) byExpiration([bool asc = true]) => asc ? _byExpiration : _byExpirationDesc;
  static int Function(LicensureSummary, LicensureSummary) byStatusString([bool asc = true]) => asc ? _byStatusString : _byStatusStringDesc;
  static int Function(LicensureSummary, LicensureSummary) byStatusPriority([bool asc = true]) => asc ? _byStatusPriority : _byStatusPriorityDesc;
  static int Function(LicensureSummary, LicensureSummary) byRuntimeStatusString([bool asc = true]) => asc ? _byRuntimeStatusString : _byRuntimeStatusStringDesc;
  static int Function(LicensureSummary, LicensureSummary) byRuntimeStatusPriority([bool asc = true]) =>
      asc ? _byRuntimeStatusPriority : _byRuntimeStatusPriorityDesc;
  static int Function(LicensureSummary, LicensureSummary) byTypeIndex([bool asc = true]) => asc ? _byTypeIndex : _byTypeIndexDesc;
  static int Function(LicensureSummary, LicensureSummary) byTypeString([bool asc = true]) => asc ? _byTypeString : _byTypeStringDesc;
  static int Function(LicensureSummary, LicensureSummary) byName([bool asc = true]) => asc ? _byName : _byNameDesc;

  static int _byExpiration(LicensureSummary a, LicensureSummary b) {
    if (a.expiration == null && b.expiration == null) {
      return 0;
    } else if (a.expiration == null) {
      return -1;
    } else if (b.expiration == null) {
      return 1;
    }

    return a.expiration!.compareTo(b.expiration!);
  }

  static int _byExpirationDesc(LicensureSummary a, LicensureSummary b) => _byExpiration(a, b) * -1;

  static int _byStatusPriority(LicensureSummary a, LicensureSummary b) {
    return (a.status.index - b.status.index).clamp(-1, 1);
  }

  static int _byStatusPriorityDesc(LicensureSummary a, LicensureSummary b) => _byStatusPriority(a, b) * -1;

  static int _byStatusString(LicensureSummary a, LicensureSummary b) {
    return a.status.toString().compareTo(b.status.toString());
  }

  static int _byStatusStringDesc(LicensureSummary a, LicensureSummary b) => _byStatusString(a, b) * -1;

  static int _byRuntimeStatusPriority(LicensureSummary a, LicensureSummary b) {
    return (a.runtimeStatus.index - b.runtimeStatus.index).clamp(-1, 1);
  }

  static int _byRuntimeStatusPriorityDesc(LicensureSummary a, LicensureSummary b) => _byRuntimeStatusPriority(a, b) * -1;

  static int _byRuntimeStatusString(LicensureSummary a, LicensureSummary b) {
    return a.runtimeStatus.toString().compareTo(b.runtimeStatus.toString());
  }

  static int _byRuntimeStatusStringDesc(LicensureSummary a, LicensureSummary b) => _byRuntimeStatusString(a, b) * -1;

  static int _byName(LicensureSummary a, LicensureSummary b) {
    if (a.person == null && b.person == null) {
      return 0;
    } else if (a.person == null) {
      return -1;
    } else if (b.person == null) {
      return 1;
    }

    return a.person!.displayName().compareTo(b.person!.displayName());
  }

  static int _byNameDesc(LicensureSummary a, LicensureSummary b) => _byName(a, b) * -1;

  static int _byTypeIndex(LicensureSummary a, LicensureSummary b) {
    if (a.licensureType == null && b.licensureType == null) {
      return 0;
    } else if (a.licensureType == null) {
      return -1;
    } else if (b.licensureType == null) {
      return 1;
    }

    return (a.licensureType!.index - b.licensureType!.index).clamp(-1, 1);
  }

  static int _byTypeIndexDesc(LicensureSummary a, LicensureSummary b) => _byTypeIndex(a, b) * -1;

  static int _byTypeString(LicensureSummary a, LicensureSummary b) {
    return a.licensureType.toString().compareTo(b.licensureType.toString());
  }

  static int _byTypeStringDesc(LicensureSummary a, LicensureSummary b) => _byTypeString(a, b) * -1;
}

/// A class for building a custom sort function from the given [_sortFunctions].
///
/// Example: The following code will sort the list by expiration date, then by status, then by name.
///
/// ```dart
/// LicensureSummarySortBuilder builder = LicensureSummarySortBuilder([
///   LicensureSummarySorting.byExiration,
///   LicensureSummarySorting.byStatus,
///   LicensureSummarySorting.byName,
/// ]);
///
/// <LicensureSummary>[
///   ...
/// ].sort(builder.sort);
/// ```
class LicensureSummarySortBuilder {
  final List<int Function(LicensureSummary, LicensureSummary)> _sortFunctions;

  const LicensureSummarySortBuilder([List<int Function(LicensureSummary, LicensureSummary)>? sortFunctions])
      : _sortFunctions = sortFunctions ?? const <int Function(LicensureSummary, LicensureSummary)>[];

  void add(int Function(LicensureSummary, LicensureSummary) sortFunction) => _sortFunctions.add(sortFunction);
  void insert(int index, int Function(LicensureSummary, LicensureSummary) sortFunction) => _sortFunctions.insert(index, sortFunction);
  bool remove(int Function(LicensureSummary, LicensureSummary) sortFunction) => _sortFunctions.remove(sortFunction);

  /// Uses the [_sortFunctions] to compare [a] and [b].
  ///
  /// Iterates through the [_sortFunctions] until a non-zero result is returned or the list is exhausted.
  int sort(LicensureSummary a, LicensureSummary b) {
    int result = 0;

    for (int Function(LicensureSummary, LicensureSummary) func in _sortFunctions) {
      result = func.call(a, b);

      if (result != 0) break;
    }

    return result;
  }
}
