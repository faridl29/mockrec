# Changelog

## 0.0.2

* Updated `dio` dependency lower bound to `^5.4.0` to ensure compatibility with `DioException` and pass static analysis constraints.
* Renamed package and references to `mockrec` for cleaner API usage (`Mockrec.enable()`).
* Revamped documentation and README for better clarity and features highlight.

## 0.0.1

* Initial release.
* `Mockrec.enable()` — attach the recording interceptor to any Dio instance.
* `Mockrec.setMockMode()` — toggle between recording and replay mode.
* `Mockrec.clear()` — clear all recorded mock data.
* `MockInterceptor` — Dio interceptor that records responses and replays them in mock mode.
* In-memory storage with simple `METHOD_PATH` cache key strategy.
