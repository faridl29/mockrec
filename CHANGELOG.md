# Changelog

## 0.0.1

* Initial release.
* `MockRecorder.enable()` — attach the recording interceptor to any Dio instance.
* `MockRecorder.setMockMode()` — toggle between recording and replay mode.
* `MockRecorder.clear()` — clear all recorded mock data.
* `MockInterceptor` — Dio interceptor that records responses and replays them in mock mode.
* In-memory storage with simple `METHOD_PATH` cache key strategy.
