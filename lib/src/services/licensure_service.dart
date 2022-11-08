import 'dart:convert';

import 'package:http/http.dart' as http;

import '../data/licensure_details.dart';
import '../data/licensure_summary.dart';
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

abstract class ServiceDataException extends ServiceException {
  ServiceDataException({required super.message, super.inner});
}

class LicensureTypeRequiredException extends ServiceDataException {
  LicensureTypeRequiredException() : super(message: 'Licensure Type required.');
}

class PersonRequiredException extends ServiceDataException {
  PersonRequiredException() : super(message: 'Person required.');
}

class HttpLicensureService extends HttpServiceBase<LicensureEndpoints> implements LicensureService {
  HttpLicensureService(
    super.baseUrl, {
    super.endpoints = const LicensureEndpoints(),
    http.Client? client,
  }) : super(client: client ?? http.Client());

  /// Attempts to fetch the [LicensureSummary] list.
  ///
  /// Throws a [HttpServiceException] if a request-related error occurs.
  /// Throws a [ServiceException] if a non-200 status code is returned.
  @override
  Future<List<LicensureSummary>> fetchLicensureList() async {
    Uri uri = Uri.parse(baseUrl + endpoints.list);

    late http.Response response;
    try {
      response = await client.get(uri);
    } on Exception catch (ex) {
      throw HttpServiceException.connectionError(
        prependedMessage: 'Unable to get list.',
        inner: ex,
      );
    }

    if (response.statusCode != 200) {
      throw HttpServiceException.fromJson(jsonDecode(response.body) as Map<String, dynamic>, response.statusCode);
    }

    List<dynamic> json = jsonDecode(response.body) as List<dynamic>;
    return json.map((raw) => LicensureSummary.fromJson(raw)).toList();
  }

  @override
  Future<LicensureDetails> getLicensureDetailsById(int id) async {
    Uri uri = Uri.parse('$baseUrl${endpoints.get}/$id');

    http.Response response;
    try {
      response = await client.get(uri);
    } on Exception catch (ex) {
      throw HttpServiceException.connectionError(
        prependedMessage: 'Unable to get the licensure.',
        inner: ex,
      );
    }

    if (response.statusCode != 200) {
      throw response.body.isEmpty
          ? HttpServiceException.statusCode(response.statusCode)
          : throw HttpServiceException.fromJson(jsonDecode(response.body), response.statusCode);
    }

    return LicensureDetails.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  @override
  Future<bool> saveLicensureDetails(LicensureDetails details) {
    if (details.person == null) throw PersonRequiredException();
    if (details.licensureType == null) throw LicensureTypeRequiredException();

    if (details.isNewRecord) {
      return _saveNewLicensure(details);
    }

    return _updateLicensure(details);
  }

  Future<bool> _saveNewLicensure(LicensureDetails details) async {
    Uri uri = Uri.parse('$baseUrl${endpoints.create}');

    http.Response response;

    try {
      response = await client.post(uri);
    } on Exception catch (ex) {
      throw HttpServiceException.connectionError(
        prependedMessage: 'Licensure was not saved',
        inner: ex,
      );
    }

    if (response.statusCode != 200) {
      throw HttpServiceException.fromJson(jsonDecode(response.body) as Map<String, dynamic>, response.statusCode);
    }

    return true;
  }

  Future<bool> _updateLicensure(LicensureDetails details) async {
    Uri uri = Uri.parse('$baseUrl${endpoints.update}/${details.id}');

    http.Response response;

    try {
      response = await client.post(uri, body: details.toJson());
    } on Exception catch (ex) {
      throw HttpServiceException.connectionError(
        prependedMessage: 'Licensure was not updated',
        inner: ex,
      );
    }

    if (response.statusCode != 200) {
      Map<String, dynamic>? json = jsonDecode(response.body) as Map<String, dynamic>?;
      throw json == null
          ? HttpServiceException.statusCode(response.statusCode)
          : throw HttpServiceException.fromJson(json, response.statusCode);
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
