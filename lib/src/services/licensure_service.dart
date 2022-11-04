import 'dart:convert';

import 'package:http/http.dart' as http;

import '../utils/application_exception.dart';
import '../data/licensure_details.dart';
import '../data/licensure_summary.dart';
import '../utils/http_exceptions.dart';
import 'http_service_base.dart';

/// The service responsible for making [LicensureSummary]-related data requests.
abstract class LicensureService {
  LicensureService();

  Future<List<LicensureSummary>> fetchLicensureList();

  Future<LicensureDetails> getLicensureDetailsById(int id);

  /// Saves [details] to the database.
  ///
  /// On success, updates new records with their id and sets isModified to false.
  ///
  /// Throws a [LicensureTypeRequiredException] when [details.licensureType] is null.
  /// Throws a [PersonRequiredException] when [details.person] is null.
  Future<bool> saveLicensureDetails(LicensureDetails details);
}

abstract class DataException extends ApplicationException {
  DataException({required super.message});
}

class LicensureTypeRequiredException extends DataException {
  LicensureTypeRequiredException() : super(message: 'Licensure Type required.');
}

class PersonRequiredException extends DataException {
  PersonRequiredException() : super(message: 'Person required.');
}

class HttpLicensureService extends HttpServiceBase<LicensureEndpoints> implements LicensureService {
  HttpLicensureService(
    super.baseUrl, {
    super.endpoints = const LicensureEndpoints(),
    http.Client? client,
  }) : super(client: client ?? http.Client());

  @override
  Future<List<LicensureSummary>> fetchLicensureList() async {
    Uri uri = Uri.parse(baseUrl + endpoints.list);

    http.Response response = await client.get(uri);

    if (response.statusCode != 200) {
      throw ServiceException.fromJson(jsonDecode(response.body) as Map<String, dynamic>, response.statusCode);
    }

    List<dynamic> json = jsonDecode(response.body) as List<dynamic>;
    return json.map((raw) => LicensureSummary.fromJson(raw)).toList();
  }

  @override
  Future<LicensureDetails> getLicensureDetailsById(int id) async {
    Uri uri = Uri.parse('$baseUrl${endpoints.get}/$id');

    http.Response response = await client.get(uri);

    if (response.statusCode != 200) {
      throw response.body.isEmpty
          ? ServiceException.statusCode(response.statusCode)
          : throw ServiceException.fromJson(jsonDecode(response.body), response.statusCode);
    }

    return LicensureDetails.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  @override
  Future<bool> saveLicensureDetails(LicensureDetails details) {
    if (details.isNewRecord) {
      return _saveNewLicensure(details);
    }

    return _updateLicensure(details);
  }

  Future<bool> _saveNewLicensure(LicensureDetails details) async {
    Uri uri = Uri.parse('$baseUrl${endpoints.create}');

    http.Response response = await client.post(uri);

    if (response.statusCode != 200) {
      throw ServiceException.fromJson(jsonDecode(response.body) as Map<String, dynamic>, response.statusCode);
    }

    return true;
  }

  Future<bool> _updateLicensure(LicensureDetails details) async {
    Uri uri = Uri.parse('$baseUrl${endpoints.update}/${details.id}');

    http.Response response = await client.post(uri, body: details.toJson());

    if (response.statusCode != 200) {
      Map<String, dynamic>? json = jsonDecode(response.body) as Map<String, dynamic>?;
      throw json == null
          ? ServiceException.statusCode(response.statusCode)
          : throw ServiceException.fromJson(json, response.statusCode);
    }

    return true;
  }
}

class LicensureEndpoints implements HttpEndpoints {
  final String get;
  final String create;
  final String update;
  final String list;

  const LicensureEndpoints({
    this.get = '/licensures',
    this.create = '/licensures/new',
    this.update = '/licensures',
    this.list = '/licensures/list',
  });
}
