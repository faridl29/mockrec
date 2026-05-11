/// Core implementation of the mockrec package.
///
/// Provides the main [MockRecorder] class with static methods
/// to enable recording, toggle mock mode, and manage stored data.
library;

import 'package:dio/dio.dart';

import 'mock_interceptor.dart';
import 'mock_storage.dart';

/// Lightweight API recorder for Dio.
///
/// `MockRecorder` lets you record real API responses and replay them
/// without hitting the backend. Attach it to any Dio instance with
/// [enable], then toggle between recording and replay using
/// [setMockMode].
///
/// ## Usage
///
/// ```dart
/// final dio = Dio();
///
/// // Attach the interceptor
/// MockRecorder.enable(dio);
///
/// // Normal mode — records API responses
/// await dio.get('/user');
///
/// // Enable mock mode — replays from memory
/// MockRecorder.setMockMode(true);
/// await dio.get('/user'); // returns recorded response
/// ```
///
/// ## Key Methods
///
/// | Method | Description |
/// |---|---|
/// | [enable] | Attach the recording interceptor to a Dio instance |
/// | [setMockMode] | Toggle between recording and replay mode |
/// | [isMockMode] | Check current mode |
/// | [clear] | Clear all recorded data |
class MockRecorder {
  MockRecorder._();

  /// Internal interceptor instance.
  ///
  /// Created lazily when [enable] is first called. Shared across
  /// all Dio instances to ensure a single source of mock state.
  static MockInterceptor? _interceptor;

  /// Attaches the mock recording interceptor to the given [dio] instance.
  ///
  /// This must be called before any API requests are made. The
  /// interceptor will automatically record responses in normal mode
  /// and replay them when mock mode is enabled.
  ///
  /// Safe to call multiple times — only one interceptor is added.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final dio = Dio();
  /// MockRecorder.enable(dio);
  /// ```
  static void enable(Dio dio) {
    _interceptor ??= MockInterceptor();
    // Prevent duplicate interceptor registration.
    if (!dio.interceptors.contains(_interceptor)) {
      dio.interceptors.add(_interceptor!);
    }
  }

  /// Toggles mock mode on or off.
  ///
  /// When [value] is `true`, all subsequent Dio requests will be
  /// intercepted and replayed from recorded data instead of hitting
  /// the real backend.
  ///
  /// When [value] is `false` (default), requests pass through to the
  /// real backend and responses are automatically recorded.
  ///
  /// ## Example
  ///
  /// ```dart
  /// // Switch to replay mode
  /// MockRecorder.setMockMode(true);
  ///
  /// // Switch back to recording mode
  /// MockRecorder.setMockMode(false);
  /// ```
  static void setMockMode(bool value) {
    _interceptor?.isMockMode = value;
  }

  /// Returns `true` if mock mode is currently active.
  ///
  /// ## Example
  ///
  /// ```dart
  /// if (MockRecorder.isMockMode) {
  ///   print('Running in mock mode');
  /// }
  /// ```
  static bool get isMockMode => _interceptor?.isMockMode ?? false;

  /// Clears all recorded mock data from memory.
  ///
  /// Use this to reset the recorder state, for example between
  /// test runs or when switching API environments.
  ///
  /// ## Example
  ///
  /// ```dart
  /// MockRecorder.clear();
  /// ```
  static void clear() {
    MockStorage.clear();
  }
}
