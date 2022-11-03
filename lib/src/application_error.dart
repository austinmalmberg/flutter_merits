abstract class ApplicationException implements Exception {
  /// A user-friendly message describing the error.
  final String message;

  ApplicationException({required this.message}) : super();
}

/// Wraps another [Exception].
///
/// Intended to provide user-friendly messages for a low-level [Exception].
abstract class ApplicationWrapperException extends ApplicationException {
  final Exception inner;

  ApplicationWrapperException({required super.message, required this.inner});
}
