import 'dart:async';
import 'package:energy_dashboard/data_service.dart';

class EnergyDashboardController {
  final DataService dataService = DataService();

  // Variables to store fetched data
  double? temperature;
  double? lightIntensity;
  double? potentiometerVoltage;
  double? solarPanelVoltage;
  String powerMode = "Unknown";
  double? prediction;

  // Weather-specific variables
  String? weatherDescription;
  double? weatherTemperature;

  // Method to update energy data from Flask server
  Future<void> updateEnergyData() async {
    try {
      final data = await dataService.fetchData();

      // Parse the Flask server response
      temperature = data['temperature']?.toDouble() ?? 0.0;
      lightIntensity = data['light_intensity']?.toDouble() ?? 0.0;
      potentiometerVoltage = data['potentiometer_voltage']?.toDouble() ?? 0.0;
      solarPanelVoltage = data['solar_panel_voltage']?.toDouble() ?? 0.0;

      // You can calculate or set `powerMode` or `prediction` if necessary
      powerMode = potentiometerVoltage != null && solarPanelVoltage != null
          ? (potentiometerVoltage! > solarPanelVoltage! ? "Strained" : "Optimal")
          : "Unknown";
    } catch (error) {
      print('Error fetching energy data: $error');
      // Reset data to prevent stale values
      temperature = 0.0;
      lightIntensity = 0.0;
      potentiometerVoltage = 0.0;
      solarPanelVoltage = 0.0;
      powerMode = "Unknown";
    }
  }

  // Method to update weather data
  Future<void> updateWeatherData() async {
    try {
      final weatherData = await dataService.fetchWeatherData("Pretoria");

      // Parse the OpenWeatherMap response
      weatherDescription = weatherData['weather'][0]['description'];
      weatherTemperature = weatherData['main']['temp'];
    } catch (error) {
      print('Error fetching weather data: $error');
      // Reset weather data
      weatherDescription = "Unavailable";
      weatherTemperature = 0.0;
    }
  }

  // Periodically update both energy and weather data
  void startPeriodicUpdates(Duration interval) {
    Timer.periodic(interval, (Timer t) async {
      await updateEnergyData();
      await updateWeatherData();
    });
  }
}
