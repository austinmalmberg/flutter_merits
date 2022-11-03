import 'package:flutter/cupertino.dart';

import '../data/licensure_summary.dart';
import '../services/licensure_service.dart';

class LicensureProvider extends ChangeNotifier {
  LicensureProvider([LicensureService? service, LicensureSummarySortBuilder? sortBuilder])
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
  /// The list will be sorted as directed by the [sortBuilder] or [sortOrder], when provided, and the original sort function will be overridden. Otherwise, the original sort ordering will be used.
  Future<void> fetchOverviewList() async {
    assert(_service != null, '''
      The LicensureService is null. Use setService(LicensureService) before using this method.
    ''');

    _licensures = await _service!.fetchOverviewList();
    _licensures?.sort(sortOrder);

    notifyListeners();
  }
}
