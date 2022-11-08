import 'package:flutter_merits/src/data/activity_entry.dart';
import 'package:flutter_merits/src/data/licensure_details.dart';
import 'package:flutter_merits/src/data/licensure_status.dart';
import 'package:flutter_merits/src/data/licensure_summary.dart';
import 'package:flutter_merits/src/data/licensure_type.dart';
import 'package:flutter_merits/src/data/person.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Person person = Person(
    firstName: 'John',
    lastName: 'Doe',
    status: EmploymentStatus.active,
    ssn: '1234',
    area: 'Admissions',
    department: '',
    title: 'Specialist',
  );
  LicensureSummary summary = LicensureSummary(
    id: 1,
    status: LicensureStatus.active,
    person: person,
    licensureType: LicensureType.cna,
  );
  ActivityEntry entry = ActivityEntry(
    timestamp: DateTime.now(),
    creator: person,
    comment: 'Verified',
  );
  LicensureDetails details = LicensureDetails.fromSummary(
    summary,
    comment: 'This is a sample comment',
    activityLog: <ActivityEntry>[
      entry,
    ],
  );

  test('ActivityEntry serializes and deserializes correctly', () {
    Map<String, dynamic> json = entry.toJson();

    expect(ActivityEntry.fromJson(json), entry);
  });

  test('Person serializes and deserializes correctly', () {
    Map<String, dynamic> json = person.toJson();

    expect(Person.fromJson(json), person);
  });

  test('LicensureSummary serializes and deserializes correctly', () {
    Map<String, dynamic> json = summary.toJson();

    expect(LicensureSummary.fromJson(json), summary);
  });

  test('LicensureDetails serializes and deserializes correctly', () {
    Map<String, dynamic> json = details.toJson();

    expect(LicensureDetails.fromJson(json), details);
  });
}
