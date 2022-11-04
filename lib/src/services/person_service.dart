import 'dart:convert';

import 'package:flutter_merits/src/utils/http_exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_merits/src/services/http_service_base.dart';

import '../data/person.dart';

/// The service responsible for making [Person]-related data requests.
abstract class PersonService {
  const PersonService();

  Future<List<Person>> fetchPersonsByLikeName(String text);
}

class HttpPersonService extends HttpServiceBase<PersonEndpoints> implements PersonService {
  HttpPersonService(
    super.baseUrl, {
    super.endpoints = const PersonEndpoints(),
    http.Client? client,
  }) : super(client: client ?? http.Client());

  @override
  Future<List<Person>> fetchPersonsByLikeName(String text) async {
    Uri url = Uri.parse('$baseUrl${endpoints.search}?text=$text');

    http.Response response = await client.get(url);

    if (response.statusCode != 200) {
      throw response.body.isEmpty
          ? ServiceException.statusCode(response.statusCode)
          : ServiceException.fromJson(jsonDecode(response.body) as Map<String, dynamic>, response.statusCode);
    }

    List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    return data.map((raw) => Person.fromJson(raw as Map<String, dynamic>)).toList();
  }
}

class PersonEndpoints implements HttpEndpoints {
  final String search;

  const PersonEndpoints({
    this.search = '/persons',
  });
}
