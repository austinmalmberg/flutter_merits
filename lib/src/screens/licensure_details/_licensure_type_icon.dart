import 'package:flutter/material.dart';

import '../../data/licensure_type.dart';
import '../../theme/licensure_type.dart';
import '../../theme/theme_data.dart';

class LicensureTypeIcon extends StatelessWidget {
  final LicensureType type;
  final double? size;

  const LicensureTypeIcon({Key? key, required this.type, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.star,
      size: size,
      color: getLicensureTypeColor(type),
      shadows: iconShadows(context),
    );
  }
}
