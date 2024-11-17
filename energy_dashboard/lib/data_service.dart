import 'package:http/http.dart' as http;
import 'dart:convert';

class DataService {
  // Base URL for Flask server
  final String baseUrl = 'http://127.0.0.1:5000/data';

  // Base URL and API key for OpenWeatherMap
  final String weatherApiUrl = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey = "4b8fce8675e61cc8de7c4890d6f1dc0a";

  // Fetch real-time data from Flask server
  Future<Map<String, dynamic>> fetchData() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data from Flask server: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching data from Flask server: $error');
    }
  }

  // Fetch weather data from OpenWeatherMap
  Future<Map<String, dynamic>> fetchWeatherData(String city) async {
    try {
      final response = await http.get(
        Uri.parse('$weatherApiUrl?q=$city&appid=$apiKey&units=metric'),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching weather data: $error');
    }
  }
}
