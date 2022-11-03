// ignore_for_file: constant_identifier_names

import 'package:flutter_merits/src/data/licensure_summary.dart';

abstract class Routes {
  static const String home = '/';

  static const String settings = '/settings';

  static const String details = '/details';
}

class LicensureDetailsArguments {
  final LicensureSummary? summary;
  final int? index;

  LicensureDetailsArguments({this.summary, this.index});
}
