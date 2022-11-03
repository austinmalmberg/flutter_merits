import 'package:flutter/material.dart';

enum LicensureType {
  cna,
  rn,
  lpn;

  @override
  String toString() => name.toUpperCase();
}

extension LicensureTypeExtensions on LicensureType {
  Color get color {
    return Colors.primaries[index];
  }
}
