import 'package:flutter_merits/src/services/person_service.dart';

import '../data/person.dart';
import 'test_data.dart';

class TestPersonService implements PersonService {
  const TestPersonService();

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
