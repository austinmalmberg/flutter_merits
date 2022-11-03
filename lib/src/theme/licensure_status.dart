import 'package:flutter/material.dart';

import '../data/licensure_status.dart';

extension _LicensureStatusExtensions on LicensureStatus {
  Color get color {
    switch (this) {
      case LicensureStatus.pending:
        return const Color.fromARGB(255, 196, 177, 10);
      case LicensureStatus.active:
        return const Color.fromARGB(255, 18, 231, 143);
      case LicensureStatus.inactive:
        return Colors.grey;
      case LicensureStatus.expired:
        return Colors.red;
    }
  }
}

Color getLicensureStatusColor(LicensureStatus status) => status.color;
