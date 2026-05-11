import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockrec/mockrec.dart';
import 'package:mockrec/src/mock_storage.dart';

void main() {
  late Dio dio;

  setUp(() {
    MockStorage.clear();
    MockRecorder.setMockMode(false);
    dio = Dio();
    // Using http://example.com to avoid real network calls if possible,
    // but interceptor mock mode should catch it before network.
    // For normal mode tests we will use an interceptor to mock the real network
    // so we don't actually hit the internet.
    dio.options.baseUrl = 'http://example.com';
    MockRecorder.enable(dio);

    // Add a fake backend interceptor to simulate real network responses
    // when mock mode is OFF.
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // If the mock recorder didn't intercept it (i.e. mock mode is OFF),
          // we simulate a real network response here.
          handler.resolve(
            Response(
              requestOptions: options,
              data: {'message': 'real data'},
              statusCode: 200,
            ),
          );
        },
      ),
    );
  });

  group('MockRecorder', () {
    test('isMockMode defaults to false', () {
      expect(MockRecorder.isMockMode, isFalse);
    });

    test('setMockMode toggles mode', () {
      MockRecorder.setMockMode(true);
      expect(MockRecorder.isMockMode, isTrue);

      MockRecorder.setMockMode(false);
      expect(MockRecorder.isMockMode, isFalse);
    });

    test('records response in normal mode', () async {
      final response = await dio.get('/test');

      expect(response.data, {'message': 'real data'});
      expect(response.statusCode, 200);

      // Verify it was saved to storage
      expect(MockStorage.length, 1);
      expect(MockStorage.containsKey('GET_/test'), isTrue);
    });

    test('replays recorded response in mock mode', () async {
      // 1. Record
      await dio.get('/test');
      expect(MockStorage.length, 1);

      // 2. Enable mock mode
      MockRecorder.setMockMode(true);

      // 3. Replay (we temporarily remove our fake backend interceptor to prove
      // it's the mockrec that's returning the data).
      dio.interceptors.removeLast();

      final response = await dio.get('/test');

      expect(response.data, {'message': 'real data'});
      expect(response.statusCode, 200);
    });

    test('throws error in mock mode if no data exists', () async {
      MockRecorder.setMockMode(true);

      expect(
        () => dio.get('/unrecorded'),
        throwsA(
          isA<DioException>().having(
            (e) => e.error.toString(),
            'error message',
            contains('No mock data found'),
          ),
        ),
      );
    });

    test('clear() removes all recorded data', () async {
      await dio.get('/test1');
      await dio.get('/test2');

      expect(MockStorage.length, 2);

      MockRecorder.clear();

      expect(MockStorage.length, 0);
    });
  });
}
