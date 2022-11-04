import 'package:flutter_merits/src/services/person_service.dart';

import '../data/person.dart';
import 'test_data.dart';

class LocalTestPersonService implements PersonService {
  const LocalTestPersonService();

  @override
  Future<List<Person>> fetchPersonsByLikeName(String text) async {
    await Future.delayed(const Duration(milliseconds: 600));

    return <Person>[
      samplePerson,
      samplePerson,
      samplePerson,
      samplePerson,
      samplePerson,
      samplePerson,
      samplePerson,
      samplePerson,
      samplePerson,
      samplePerson,
      samplePerson,
    ];
  }
}

class HttpTestPersonService extends HttpPersonService {
  HttpTestPersonService() : super('http://localhost:5000');
}
