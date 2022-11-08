import 'dart:convert';

import 'package:flutter_merits/src/data/person.dart';
import 'package:flutter_merits/src/services/http_service_base.dart';
import 'package:flutter_merits/src/services/person_service.dart';
import 'package:flutter_merits/src/testing/test_person_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

void main() {
  HttpPersonService createPersonService(MockClient client) => DevHttpPersonService(client);

  test('fetchPersonsByLikeName(text) returns the correct data', () async {
    String text = 'smau';
    HttpPersonService service = createPersonService(MockPersonClientFactory.fetchPersonsByLikeName(text));

    List<Person> result = await service.fetchPersonsByLikeName(text);

    expect(result, isNot(null));
    expect(result.isNotEmpty, true);
    expect(result[0].lastName.contains(text), true);
    expect(result[0].firstName.contains(text), true);
  });

  test('passing a search string less than 3 characters to fetchPersonsByLikeName(text) throws an exception', () async {
    String text = 'sm';
    HttpPersonService service = createPersonService(MockPersonClientFactory.fetchPersonsByLikeName(text));

    expect(
      () async => await service.fetchPersonsByLikeName(text),
      throwsA(predicate((error) =>
          error is HttpServiceException &&
          error.statusCode == 400 &&
          error.message.toLowerCase() == 'Invalid search'.toLowerCase())),
    );
  });
}

abstract class MockPersonClientFactory {
  static MockClient fetchPersonsByLikeName(String text) {
    late Response response;
    if (text.length < 3) {
      response = Response('{"error":"Invalid search"}', 400);
    } else {
      List<Person> list = _personList(text);
      response = Response(jsonEncode(list), 200);
    }

    return MockClient((request) => Future.value(response));
  }

  static List<Person> _personList(String text) {
    return <Person>[
      Person(
        firstName: text,
        lastName: text,
        status: EmploymentStatus.active,
        ssn: '1234',
        department: '',
        area: 'Admissions',
        title: 'Specialist',
      ),
    ];
  }
}
