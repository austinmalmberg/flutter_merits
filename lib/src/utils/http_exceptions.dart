import 'application_exception.dart';

class ServiceException extends ApplicationException {
  final int? statusCode;
  final String error;

  ServiceException({required this.error, required String message, this.statusCode}) : super(message: message);

  factory ServiceException.statusCode(int? statusCode) => ServiceException(
        error: 'Status $statusCode',
        message: 'Action returned a status code $statusCode.',
        statusCode: statusCode,
      );

  factory ServiceException.fromJson(Map<String, dynamic> json, [int? statusCode]) => ServiceException(
        error: json['error'] ?? json['title'],
        message: json['message'] ?? json['type'],
        statusCode: statusCode,
      );
}
