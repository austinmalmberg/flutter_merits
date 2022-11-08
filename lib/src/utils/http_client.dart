import 'package:flutter_merits/src/services/http_service_base.dart';
import 'package:http/http.dart' as http;

class MyHttpClient extends http.BaseClient {
  final http.Client _inner;

  MyHttpClient(http.Client? client)
      : _inner = client ?? http.Client(),
        super();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request, [String? s]) {
    try {
      return _inner.send(request);
    } on Exception catch (ex) {
      throw HttpServiceException(inner: ex);
    }
  }

  @override
  void close() {
    _inner.close();
  }
}
