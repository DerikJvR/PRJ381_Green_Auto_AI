import 'package:http/http.dart' as http;
import 'dart:convert';

class DataService {
  final String baseUrl = 'http://10.0.2.2:5000/data'; // Update with your server's IP if not on emulator
  final String weatherApiUrl = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey = "4b8fce8675e61cc8de7c4890d6f1dc0a";

  Future<Map<String, dynamic>> fetchData() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data from server');
      }
    } catch (error) {
      throw Exception('Error fetching server data: $error');
    }
  }

  Future<Map<String, dynamic>> fetchWeatherData(String city) async {
    try {
      final response = await http.get(
        Uri.parse('$weatherApiUrl?q=$city&appid=$apiKey&units=metric'),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (error) {
      throw Exception('Error fetching weather data: $error');
    }
  }
}
