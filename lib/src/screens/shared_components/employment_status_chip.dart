import 'package:flutter/material.dart';
import 'package:flutter_merits/src/data/person.dart';

import '../../theme/employment_status.dart';

class EmploymentStatusChip extends StatelessWidget {
  const EmploymentStatusChip({Key? key, required this.status, this.scale = 1.0}) : super(key: key);

  final EmploymentStatus status;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0 * scale, horizontal: 8.0 * scale),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: getEmploymentStatusColor(status),
      ),
      child: Text(
        status.toString(),
        textScaleFactor: scale,
        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
      ),
    );
  }
}
