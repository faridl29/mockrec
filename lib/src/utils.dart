/// Utility functions for the mockrec package.
///
/// Provides helper functions used internally by the interceptor
/// to generate consistent cache keys from Dio request options.
library;

import 'package:dio/dio.dart';

/// Generates a unique cache key from a [RequestOptions] instance.
///
/// The key is constructed from the HTTP method and the request path,
/// separated by an underscore:
///
/// ```dart
/// // GET /user → 'GET_/user'
/// // POST /login → 'POST_/login'
/// ```
///
/// This provides a simple, deterministic key that uniquely identifies
/// each endpoint while keeping the storage map readable.
String generateKey(RequestOptions request) {
  return '${request.method}_${request.path}';
}
