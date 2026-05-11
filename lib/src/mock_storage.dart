/// In-memory storage for recorded API responses.
///
/// This file contains the simple map-based storage that holds
/// recorded response data keyed by request method and path.
library;

/// Global in-memory storage for recorded API responses.
///
/// Maps cache keys (generated from request method and path) to their
/// corresponding response data. This is the single source of truth
/// for all recorded mock data.
///
/// ## Example
///
/// A typical entry looks like:
///
/// ```dart
/// {
///   'GET_/user': {
///     'data': {'name': 'John'},
///     'statusCode': 200,
///     'headers': { ... },
///   },
/// }
/// ```
class MockStorage {
  MockStorage._();

  /// Internal storage map.
  ///
  /// Keys are generated via [generateKey] (e.g. `GET_/user`).
  /// Values are [MockEntry] instances containing the full response data.
  static final Map<String, MockEntry> _storage = {};

  /// Stores a [MockEntry] under the given [key].
  static void set(String key, MockEntry entry) {
    _storage[key] = entry;
  }

  /// Retrieves the [MockEntry] for the given [key], or `null` if not found.
  static MockEntry? get(String key) {
    return _storage[key];
  }

  /// Returns `true` if a recorded entry exists for the given [key].
  static bool containsKey(String key) {
    return _storage.containsKey(key);
  }

  /// Removes all recorded entries from storage.
  static void clear() {
    _storage.clear();
  }

  /// Returns the number of recorded entries.
  static int get length => _storage.length;
}

/// Represents a single recorded API response.
///
/// Stores the response body [data], the HTTP [statusCode], and
/// the response [headers] so they can be faithfully replayed.
class MockEntry {
  /// The response body data.
  final dynamic data;

  /// The HTTP status code of the recorded response.
  final int statusCode;

  /// The response headers of the recorded response.
  final Map<String, List<String>> headers;

  /// Creates a new [MockEntry] with the given response data.
  const MockEntry({
    required this.data,
    required this.statusCode,
    required this.headers,
  });
}
