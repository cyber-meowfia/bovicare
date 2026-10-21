
import 'dart:convert';
import 'package:http/http.dart' as http;

class BoviCareApiService {
  static const String baseUrl = 'http://127.0.0.1:8000';

  Future<Map<String, dynamic>> predict({
    required double milkTemperature,
    required double milkPh,
    required double milkConductivity,
    required double somaticCellCount,
    required double milkYield,
  }) async {
    final uri = Uri.parse('$baseUrl/predict');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'milk_temperature': milkTemperature,
        'milk_ph': milkPh,
        'milk_conductivity': milkConductivity,
        'somatic_cell_count': somaticCellCount,
        'milk_yield': milkYield,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'BoviCare API error: ${response.statusCode} ${response.body}',
      );
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
