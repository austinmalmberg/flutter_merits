enum LicensureStatus {
  expired,
  pending,
  active,
  inactive;

  @override
  String toString() => name[0].toUpperCase() + name.substring(1);
}
