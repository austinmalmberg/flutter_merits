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

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        firstName: json['firstName'],
        lastName: json['lastName'],
        status: EmploymentStatus.values
            .firstWhere((element) => element.toString().toLowerCase() == json['status'].toString().toLowerCase()),
        ssn: json['ssn'],
        department: json['department'] ?? '',
        area: json['area'] ?? '',
        title: json['title'] ?? '',
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'firstName': firstName,
        'lastName': lastName,
        'status': status.toString(),
        'ssn': ssn,
        'department': department,
        'area': area,
        'title': title,
      };

  @override
  bool operator ==(Object other) {
    if (other is! Person) return false;

    return firstName == other.firstName &&
        lastName == other.lastName &&
        status == other.status &&
        ssn == other.ssn &&
        department == other.department &&
        area == other.area &&
        title == other.title;
  }

  @override
  int get hashCode => super.hashCode;
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
