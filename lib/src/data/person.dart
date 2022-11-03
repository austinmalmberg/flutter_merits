class Person {
  final String firstName;
  final String lastName;
  final EmploymentStatus status;
  final String ssn;
  final String department;
  final String area;
  final String title;

  Person({
    required this.firstName,
    required this.lastName,
    required this.status,
    required this.ssn,
    required this.department,
    required this.area,
    required this.title,
  });

  String displayName() => '$lastName, $firstName';
}

enum EmploymentStatus {
  active,
  inactive,
  separated;

  @override
  String toString() {
    // Title case
    return name[0].toUpperCase() + name.substring(1);
  }
}
