import 'package:http/http.dart' as http;

import '../utils/application_exception.dart';

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

class HttpServiceException extends ServiceException {
  static const String connectionMessage =
      'Check your internet connection and try again. If the problem persists, contact the developer.';

  final int? statusCode;

  HttpServiceException({
    String message = connectionMessage,
    Exception? inner,
    this.statusCode,
  }) : super(message: message, inner: inner);

  factory HttpServiceException.connectionError({String? prependedMessage, Exception? inner}) => HttpServiceException(
        message: prependedMessage != null ? '$prependedMessage\n\n$connectionMessage' : connectionMessage,
        inner: inner,
      );

  factory HttpServiceException.statusCode(int statusCode, [String? message]) => HttpServiceException(
        message: message ?? 'Status $statusCode',
        statusCode: statusCode,
      );

  factory HttpServiceException.fromJson(Map<String, dynamic> json, [int? statusCode]) => HttpServiceException(
        message: json['error'] ?? json['message'] ?? json['type'],
        statusCode: statusCode,
      );
}

class ServiceException extends ApplicationException {
  final Exception? inner;

  ServiceException({required String message, this.inner}) : super(message: message);
}
