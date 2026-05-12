<p align="center">
  <img src="https://raw.githubusercontent.com/faridl29/mockrec/main/assets/logo.png" height="150" alt="mockrec logo" />
</p>

<p align="center">
  <h1 align="center">mockrec</h1>
  <p align="center">
    <strong>Record API once, run your Flutter app without backend.</strong>
    <br />
    <em>The ultimate Dio interceptor for offline development, testing, and flawless demos.</em>
  </p>
</p>

<p align="center">
  <a href="https://pub.dev/packages/mockrec"><img src="https://img.shields.io/pub/v/mockrec.svg" alt="pub version"></a>
  <a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart-3-0175C2.svg?logo=dart" alt="Dart 3"></a>
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.10+-02569B.svg?logo=flutter" alt="Flutter"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License: MIT"></a>
</p>

---

## 🛑 The Problem

Building Flutter apps connected to real APIs is often frustrating:
- ❌ **Backend is down** or returning 500 errors.
- ❌ **API contracts change**, breaking your UI mid-development.
- ❌ **Client demos fail** because the network is slow or unavailable.
- ❌ **Automated tests** are flaky and depend too much on external servers.

## ✨ The Solution

**`mockrec`** completely eliminates these headaches with a **single line of code**.

It works like a magic tape recorder for your network requests:
1. **🔴 Record (Normal Mode):** Browse your app normally. `mockrec` silently saves every successful API response into memory.
2. **🔁 Replay (Mock Mode):** Switch modes, and your app instantly replays those exact responses locally. No internet connection required!

> Work faster, stabilize your development environment, and deliver flawless offline demos without writing complex mock JSON files.

---

## 🚀 Key Features

- **⚡ Zero Configuration** — Just pass your Dio instance. No complex setup.
- **💾 Auto-Recording** — Automatically captures real responses, status codes, and headers.
- **✈️ Airplane Mode Ready** — Run your app completely offline using recorded data.
- **🧪 Perfect for Testing** — Isolate your UI tests from the backend effortlessly.
- **🪶 Ultra Lightweight** — Pure Dart. Only depends on `dio`.

---

## 📦 Getting Started

### Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  mockrec: ^0.0.2
  dio: ^5.4.0
```

```bash
flutter pub get
```

### ⚡ Quick Start

```dart
import 'package:dio/dio.dart';
import 'package:mockrec/mockrec.dart';

void main() async {
  final dio = Dio();

  // 1. Attach the interceptor
  Mockrec.enable(dio);

  // 2. Fetch data normally (it silently records the response!)
  await dio.get("https://jsonplaceholder.typicode.com/users/1");

  // 3. Enable Mock Mode
  Mockrec.setMockMode(true);

  // 4. Fetch again — Instant response, zero network calls!
  final response = await dio.get("https://jsonplaceholder.typicode.com/users/1");
  print(response.data);
}
```

---

## 🛠️ API Reference

### `Mockrec.enable()`

| Parameter | Type | Default | Description |
|---|---|---|---|
| `dio` | `Dio` | — | The Dio instance to attach the recording interceptor to |

Attaches the recording interceptor to your Dio instance. This must be called **before** any API requests are made.

### `Mockrec.setMockMode()`

| Parameter | Type | Default | Description |
|---|---|---|---|
| `value` | `bool` | — | `true` to enable mock replay, `false` to enable live recording |

Toggles the core engine. When set to `true`, requests will never hit the network. If no mock data exists for an endpoint, a clear `DioException` is thrown to let you know.

### `Mockrec.isMockMode`

| Property | Type | Description |
|---|---|---|
| `isMockMode` | `bool` | Returns `true` if mock mode is currently active |

### `Mockrec.clear()`

Instantly clears all recorded mock data from memory. Extremely useful for resetting states between test runs or when switching user accounts.

---

## 🏗️ Architecture

```
lib/
 ├── mockrec.dart        ← Barrel export
 └── src/
      ├── mock_interceptor.dart ← Dio interceptor engine
      ├── mockrec_impl.dart ← Public static API
      ├── mock_storage.dart     ← In-memory storage & state
      └── utils.dart            ← Fast Cache Key generator
```

---

## 📋 Requirements

| Requirement | Version |
|---|---|
| Dart SDK | `>=3.0.0 <4.0.0` |
| Flutter | `>=3.10.0` |
| Null safety | ✅ |
| Dependencies | `dio: ^5.4.0` |

---

## 💖 Support

If this package saves you time and frustration, consider supporting the development. Your support helps keep this package maintained and up-to-date!

<a href="https://sociabuzz.com/faridl29/support">
  <img src="https://img.shields.io/badge/Support_on-SociaBuzz-ff6b6b?style=for-the-badge" alt="Support on SociaBuzz">
</a>

Every contribution is greatly appreciated! 🙏

---

## 📄 License

MIT — see [LICENSE](LICENSE) for details.
# mockrec
