// path: lib/business/energy_dashboard_controller.dart

import 'dart:async';
import 'package:energy_dashboard/data_service.dart';

class EnergyDashboardController {
  final DataService dataService = DataService();
  double? temperature;
  double? lightIntensity;
  String powerMode = "Normal";
  double? prediction;
  String? weatherDescription;
  double? weatherTemperature;

  // Fetch and update energy data from the server
  Future<void> updateEnergyData() async {
    try {
      final data = await dataService.fetchData();
      temperature = data['temperature']?.toDouble() ?? 0.0;
      lightIntensity = data['light_intensity']?.toDouble() ?? 0.0;
      powerMode = data['power_mode'] ?? "Normal";
      prediction = data['prediction']?.toDouble() ?? 0.0;
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  // Fetch and update weather data
  Future<void> updateWeatherData() async {
    try {
      final weatherData = await dataService.fetchWeatherData("Pretoria");
      weatherDescription = weatherData['weather'][0]['description'];
      weatherTemperature = weatherData['main']['temp'];
    } catch (error) {
      print('Error fetching weather data: $error');
    }
  }

  // Schedule periodic data updates
  void startPeriodicUpdates(Duration interval) {
    Timer.periodic(interval, (Timer t) {
      updateEnergyData();
      updateWeatherData();
    });
  }
}
