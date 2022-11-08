import 'dart:convert';

import 'package:flutter_merits/src/data/licensure_details.dart';
import 'package:flutter_merits/src/data/licensure_status.dart';
import 'package:flutter_merits/src/data/licensure_summary.dart';
import 'package:flutter_merits/src/data/licensure_type.dart';
import 'package:flutter_merits/src/data/person.dart';
import 'package:flutter_merits/src/services/http_service_base.dart';
import 'package:flutter_merits/src/services/licensure_service.dart';
import 'package:flutter_merits/src/testing/test_licensure_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

void main() {
  LicensureService createService(MockClient client) => DevHttpLicensureService(client);

  test('fetchLicensuresList() returns the correct data', () async {
    LicensureService service = createService(MockLicensureClientFactory.fetchLicensureList());

    List<LicensureSummary> result = await service.fetchLicensureList();

    expect(result, isNot(null));
    expect(result.isNotEmpty, true);
  });

  test('getLicensureDetailsById(id) returns the licensure details', () async {
    int id = 1;
    LicensureService service = createService(MockLicensureClientFactory.getLicensureDetailsById(id));

    LicensureDetails result = await service.getLicensureDetailsById(id);

    expect(result, isNot(null));
    expect(result.id > 0, true);
  });

  test('passing an invalid id to getLicensureDetailsById(id) throws an exception', () async {
    int invalidId = -1;
    LicensureService service = createService(MockLicensureClientFactory.getLicensureDetailsById(invalidId));

    expect(
      () => service.getLicensureDetailsById(invalidId),
      throwsA(predicate((error) => error is HttpServiceException && error.statusCode == 404)),
    );
  });
}

abstract class MockLicensureClientFactory {
  static MockClient fetchLicensureList() {
    List<LicensureSummary> list = <LicensureSummary>[
      LicensureSummary(
        id: 1,
        status: LicensureStatus.active,
        person: Person(
          firstName: 'John',
          lastName: 'Doe',
          status: EmploymentStatus.active,
          ssn: '1234',
          department: '',
          area: 'Admissions',
          title: 'Specialist',
        ),
        licensureType: LicensureType.cna,
      ),
    ];

    return MockClient((request) => Future.value(Response(jsonEncode(list), 200)));
  }

  static MockClient getLicensureDetailsById(int id) {
    late Response response;
    if (id > 0) {
      LicensureSummary summary = LicensureSummary(
        id: id,
        status: LicensureStatus.active,
        person: Person(
          firstName: 'John',
          lastName: 'Doe',
          status: EmploymentStatus.active,
          ssn: '1234',
          area: 'Admissions',
          department: '',
          title: 'Specialist',
        ),
        licensureType: LicensureType.cna,
      );
      LicensureDetails details = LicensureDetails.fromSummary(summary);
      response = Response(jsonEncode(details), 200);
    } else {
      response = Response('', 404);
    }

    return MockClient((request) => Future.value(response));
  }

  static MockClient saveLicensureDetails(LicensureDetails details) {
    return MockClient((request) => Future.value(Response('', 200)));
  }
}
