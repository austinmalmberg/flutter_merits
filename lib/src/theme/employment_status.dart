import 'package:flutter/material.dart';

import '../data/person.dart';

extension _EmploymentStatusExtensions on EmploymentStatus {
  Color get color {
    switch (this) {
      case EmploymentStatus.active:
        return const Color.fromARGB(255, 18, 231, 143);
      case EmploymentStatus.inactive:
        return Colors.grey;
      case EmploymentStatus.separated:
        return Colors.red;
    }
  }
}

Color getEmploymentStatusColor(EmploymentStatus status) => status.color;
