import 'package:flutter/material.dart';

import '../data/licensure_type.dart';

Color getLicensureTypeColor(LicensureType type) => Colors.primaries[type.index % Colors.primaries.length];
