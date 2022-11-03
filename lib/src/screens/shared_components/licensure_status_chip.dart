import 'package:flutter/material.dart';

import '../../data/licensure_status.dart';
import '../../theme/licensure_status.dart';

class LicensureStatusChip extends StatelessWidget {
  const LicensureStatusChip({super.key, required this.status, this.scale = 1.0});

  final LicensureStatus status;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0 * scale, horizontal: 8.0 * scale),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: getLicensureStatusColor(status),
      ),
      child: Text(
        status.toString(),
        textScaleFactor: scale,
        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
      ),
    );
  }
}
