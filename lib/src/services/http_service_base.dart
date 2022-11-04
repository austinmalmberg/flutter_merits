import 'package:http/http.dart' as http;

abstract class HttpServiceBase<TEndpoints extends HttpEndpoints> {
  final http.Client client;
  final String baseUrl;
  final TEndpoints endpoints;

  HttpServiceBase(
    this.baseUrl, {
    required this.endpoints,
    required this.client,
  });
}

abstract class HttpEndpoints {}
