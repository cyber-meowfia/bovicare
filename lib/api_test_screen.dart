
import 'package:flutter/material.dart';
import 'bovicare_api_service.dart';

class ApiTestScreen extends StatefulWidget {
  const ApiTestScreen({super.key});

  @override
  State<ApiTestScreen> createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  final api = BoviCareApiService();
  bool loading = false;
  String result = 'Tap the button to test the Python API.';

  Future<void> testApi() async {
    setState(() {
      loading = true;
      result = 'Sending sample measurements...';
    });

    try {
      final response = await api.predict(
        milkTemperature: 35.38,
        milkPh: 6.49,
        milkConductivity: 4.68,
        somaticCellCount: 148,
        milkYield: 17.3,
      );

      setState(() {
        result = response.toString();
      });
    } catch (e) {
      setState(() {
        result = 'Connection failed: $e';
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BoviCare API Test')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Experimental Random Forest API',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: loading ? null : testApi,
                child: Text(
                  loading ? 'Testing...' : 'Test Python API',
                ),
              ),
              const SizedBox(height: 24),
              SelectableText(result),
            ],
          ),
        ),
      ),
    );
  }
}
