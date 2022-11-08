import 'package:flutter/cupertino.dart';
import 'package:flutter_merits/src/services/http_service_base.dart';

import '../data/licensure_summary.dart';
import '../services/licensure_service.dart';
import '../utils/licensure_sort.dart';

/// An object for maintaining a [LicensureSummary] list.
class LicensuresProvider extends ChangeNotifier {
  LicensuresProvider([LicensureService? service, LicensureSummarySortBuilder? sortBuilder])
      : _service = service,
        _sortBuilder = sortBuilder ??
            LicensureSummarySortBuilder([
              LicensureSummarySorting.byRuntimeStatusPriority(),
              LicensureSummarySorting.byExpiration(),
              LicensureSummarySorting.byTypeString(),
              LicensureSummarySorting.byName(),
            ]);

  LicensureSummarySortBuilder _sortBuilder;
  LicensureSummarySortBuilder get sortBuilder => _sortBuilder;
  set sortBuilder(LicensureSummarySortBuilder builder) {
    _sortBuilder = builder;

    _licensures?.sort(sortBuilder.sort);
  }

  /// The
  int Function(LicensureSummary, LicensureSummary) get sortOrder => sortBuilder.sort;

  /// The [LicensureService] used to get the lists
  LicensureService? _service;

  /// The [LicensureSummary] list.
  List<LicensureSummary>? get licensures => _licensures;
  List<LicensureSummary>? _licensures;

  void setLicensureService(LicensureService service) {
    _service = service;
  }

  ServiceException? _error;
  ServiceException? get error => _error;

  bool get hasError => error != null;

  void add(LicensureSummary summary) {
    if (_licensures == null) return;

    _licensures!.add(summary);
    _licensures!.sort(sortOrder);

    notifyListeners();
  }

  void update(int index, LicensureSummary summary) {
    if (_licensures == null) return;

    if (_licensures!.length > index) {
      _licensures![index] = summary;
      _licensures!.sort(sortOrder);

      notifyListeners();
    }
  }

  /// Fetches the [licensures] from the [LicensureService].
  ///
  /// The list will be sorted as directed by the [sortBuilder] or [sortOrder], when provided,
  /// and the original sort function will be overridden. Otherwise, the original sort ordering
  /// will be used.
  ///
  /// Throws a [ServiceException] if an error occurs.
  Future<void> fetchOverviewList() async {
    assert(_service != null, '''
      The LicensureService is null. Use setService(LicensureService) before using this method.
    ''');

    _error = null;
    _licensures = null;

    notifyListeners();

    try {
      _licensures = await _service!.fetchLicensureList();
      _licensures?.sort(sortOrder);
    } on ServiceException catch (ex) {
      _error = ex;
    }

    notifyListeners();
  }
}
