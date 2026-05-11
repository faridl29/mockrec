/// A lightweight Dio interceptor that records real API responses and
/// replays them without hitting the backend.
///
/// ## Quick Start
///
/// ```dart
/// import 'package:dio/dio.dart';
/// import 'package:mockrec/mockrec.dart';
///
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
library;

export 'src/mock_interceptor.dart' show MockInterceptor;
export 'src/mockrec_impl.dart';
export 'src/mock_storage.dart' show MockStorage;
export 'src/utils.dart' show generateKey;
