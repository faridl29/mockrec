/// Dio interceptor that records and replays API responses.
///
/// This interceptor is the core engine of the mockrec package.
/// It automatically records real API responses during normal mode
/// and replays them from memory when mock mode is enabled.
library;

import 'package:dio/dio.dart';

import 'mock_storage.dart';
import 'utils.dart';

/// A Dio [Interceptor] that records API responses and replays them.
///
/// ## Behavior
///
/// ### Recording mode (default)
///
/// When mock mode is **OFF**, the interceptor allows real API calls
/// to pass through normally. After a successful response is received,
/// it captures the response data, status code, and headers, then
/// stores them in [MockStorage] keyed by `METHOD_PATH`.
///
/// ### Replay mode
///
/// When mock mode is **ON**, the interceptor intercepts outgoing
/// requests before they reach the network. If recorded data exists
/// for the request key, it returns a [Response] with the stored data.
/// If no data is found, it rejects the request with a clear error.
///
/// ## Example
///
/// ```dart
/// final dio = Dio();
/// dio.interceptors.add(MockInterceptor());
/// ```
///
/// Typically you should use [MockRecorder.enable] instead of adding
/// this interceptor manually.
class MockInterceptor extends Interceptor {
  /// Whether mock mode is currently active.
  ///
  /// When `true`, requests are intercepted and replayed from storage.
  /// When `false`, requests pass through and responses are recorded.
  bool isMockMode = false;

  /// Intercepts outgoing requests.
  ///
  /// In mock mode, checks if recorded data exists for this request:
  /// - If found: resolves immediately with the stored response.
  /// - If not found: rejects with a [DioException] containing a
  ///   descriptive error message.
  ///
  /// In normal mode, passes the request through unchanged.
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!isMockMode) {
      // Normal mode — let the real request pass through.
      handler.next(options);
      return;
    }

    // Mock mode — attempt to replay from storage.
    final key = generateKey(options);
    final entry = MockStorage.get(key);

    if (entry != null) {
      // Found recorded data — resolve with stored response.
      handler.resolve(
        Response<dynamic>(
          requestOptions: options,
          data: entry.data,
          statusCode: entry.statusCode,
          headers: Headers.fromMap(entry.headers),
        ),
      );
    } else {
      // No recorded data — reject with a clear error message.
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.unknown,
          error: 'MockRecorder: No mock data found for [$key]. '
              'Record the API response first by making a real request '
              'with mock mode disabled.',
        ),
      );
    }
  }

  /// Records successful API responses.
  ///
  /// In normal mode (mock mode OFF), captures the response data,
  /// status code, and headers, then stores them in [MockStorage]
  /// for later replay.
  ///
  /// In mock mode, this callback is not reached because requests
  /// are resolved in [onRequest].
  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    if (!isMockMode) {
      // Record the response for future replay.
      final key = generateKey(response.requestOptions);
      MockStorage.set(
        key,
        MockEntry(
          data: response.data,
          statusCode: response.statusCode ?? 200,
          headers: response.headers.map,
        ),
      );
    }

    // Always pass the response through.
    handler.next(response);
  }
}
