import 'package:flutter_merits/src/data/licensure_details.dart';
import 'package:flutter_merits/src/data/licensure_summary.dart';
import 'package:flutter_merits/src/services/licensure_service.dart';
import 'package:flutter_merits/src/testing/test_licensure_service.dart';
import 'package:flutter_merits/src/utils/http_exceptions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  HttpLicensureService createLicensureService() => HttpTestLicensureService();

  test('fetchLicensuresList() returns the correct data', () async {
    HttpLicensureService service = createLicensureService();

    List<LicensureSummary> result = await service.fetchLicensureList();

    expect(result, isNot(null));
    expect(result.isNotEmpty, true);
  });

  test('getLicensureDetailsById(id) returns the licensure details', () async {
    HttpLicensureService service = createLicensureService();

    LicensureDetails result = await service.getLicensureDetailsById(1);

    expect(result, isNot(null));
    expect(result.id > 0, true);
  });

  test('passing an invalid id to getLicensureDetailsById(id) throws an exception', () async {
    HttpLicensureService service = createLicensureService();

    expect(
      () => service.getLicensureDetailsById(-1),
      throwsA(predicate((error) => error is ServiceException && error.statusCode == 404)),
    );
  });
}
