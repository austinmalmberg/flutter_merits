import 'package:flutter_merits/src/services/person_service.dart';
import 'package:http/http.dart' as http;

import '../data/person.dart';
import 'test_data.dart';

class LocalDevelopmentPersonService implements PersonService {
  const LocalDevelopmentPersonService();

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

class DevHttpPersonService extends HttpPersonService {
  DevHttpPersonService([http.Client? client]) : super('http://localhost:5000', client: client);
}
