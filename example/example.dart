import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mockrec/mockrec.dart';

void main() => runApp(const MockRecorderExample());

/// Example app demonstrating mockrec usage.
class MockRecorderExample extends StatelessWidget {
  /// Creates the example app.
  const MockRecorderExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mockrec Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      home: const DemoPage(),
    );
  }
}

// ─── Demo Page ────────────────────────────────────────────────────────────

/// Main demo page showing recording and replay functionality.
class DemoPage extends StatefulWidget {
  /// Creates the demo page.
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com'),
  );
  bool _isLoading = false;
  String? _result;
  bool _mockMode = false;

  @override
  void initState() {
    super.initState();
    MockRecorder.enable(_dio);
  }

  Future<void> _fetchUser() async {
    setState(() {
      _isLoading = true;
      _result = null;
    });

    try {
      final response = await _dio.get('/users/1');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _result = 'Status: ${response.statusCode}\n'
              'Name: ${response.data['name']}\n'
              'Email: ${response.data['email']}\n'
              'Mode: ${_mockMode ? 'Mock Replay' : 'Live Recording'}';
        });
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _result = 'Error: ${e.error}';
        });
      }
    }
  }

  void _toggleMockMode() {
    setState(() {
      _mockMode = !_mockMode;
      MockRecorder.setMockMode(_mockMode);
      _result = _mockMode
          ? 'Mock mode ON — replaying from memory'
          : 'Mock mode OFF — recording from API';
    });
  }

  void _clearAll() {
    MockRecorder.clear();
    setState(() => _result = 'All recorded data cleared!');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('mockrec Example')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recorder Status',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text('Mock mode: ${_mockMode ? "ON" : "OFF"}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _fetchUser,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.cloud_download),
              label: const Text('Fetch User'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _toggleMockMode,
              icon: Icon(
                _mockMode ? Icons.stop : Icons.play_arrow,
              ),
              label: Text(
                _mockMode ? 'Disable Mock Mode' : 'Enable Mock Mode',
              ),
            ),
            const SizedBox(height: 12),
            const Divider(),
            OutlinedButton.icon(
              onPressed: _clearAll,
              icon: const Icon(Icons.delete_outline),
              label: const Text('Clear Recorded Data'),
            ),
            const SizedBox(height: 24),
            if (_result != null)
              Card(
                color: _result!.contains('Error')
                    ? Colors.red.shade50
                    : _result!.contains('cleared')
                        ? Colors.orange.shade50
                        : Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _result!,
                    style: TextStyle(
                      color: _result!.contains('Error')
                          ? Colors.red.shade800
                          : _result!.contains('cleared')
                              ? Colors.orange.shade800
                              : Colors.green.shade800,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
