import 'package:flutter_merits/src/data/person.dart';
import 'package:flutter_merits/src/services/person_service.dart';
import 'package:flutter_merits/src/testing/test_person_service.dart';
import 'package:flutter_merits/src/utils/http_exceptions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  HttpPersonService createPersonService() => HttpTestPersonService();

  test('fetchPersonsByLikeName(text) returns the correct data', () async {
    HttpPersonService service = createPersonService();

    List<Person> result = await service.fetchPersonsByLikeName('smau');

    expect(result, isNot(null));
    expect(result.isNotEmpty, true);
  });

  test('passing a search string less than 3 characters to fetchPersonsByLikeName(text) throws an exception', () async {
    HttpPersonService service = createPersonService();

    expect(
      () async => await service.fetchPersonsByLikeName('sm'),
      throwsA(predicate((error) =>
          error is ServiceException &&
          error.statusCode == 400 &&
          error.error.toLowerCase() == 'Invalid search'.toLowerCase())),
    );
  });
}
