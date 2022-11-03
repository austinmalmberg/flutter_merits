import '../data/person.dart';

/// The service responsible for making [Person]-related data requests.
abstract class PersonService {
  const PersonService();

  Future<List<Person>> fetchPersonsByLikeName(String text);
}
