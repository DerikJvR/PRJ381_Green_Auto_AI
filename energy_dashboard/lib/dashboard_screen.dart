// path: lib/screens/dashboard_screen.dart

import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final VoidCallback toggleTheme;
  final ThemeMode themeMode;
  final double? temperature;
  final double? lightIntensity;
  final String powerMode;
  final double? prediction;
  final String? weatherDescription;
  final double? weatherTemperature;
  final Animation<double> animation;
  final bool isLoading;

  const DashboardScreen({
    required this.toggleTheme,
    required this.themeMode,
    required this.temperature,
    required this.lightIntensity,
    required this.powerMode,
    required this.prediction,
    required this.weatherDescription,
    required this.weatherTemperature,
    required this.animation,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Arduino Power Saver'),
        centerTitle: true,
        actions: [
          Switch(
            value: themeMode == ThemeMode.dark,
            onChanged: (value) => toggleTheme(),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : FadeTransition(
              opacity: animation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Dashboard Overview",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (weatherDescription != null && weatherTemperature != null)
                      WeatherInfoCard(
                        description: weatherDescription!,
                        temperature: weatherTemperature!,
                      ),
                    const Divider(height: 30, color: Colors.grey),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InfoCard(
                          label: "Temperature",
                          value: "${temperature?.toStringAsFixed(1) ?? '--'}°C",
                          icon: Icons.thermostat,
                        ),
                        InfoCard(
                          label: "Light Intensity",
                          value: "${lightIntensity?.toStringAsFixed(0) ?? '--'} Lux",
                          icon: Icons.light_mode,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    PowerModeDisplay(mode: powerMode), // Custom widget for power mode
                    const SizedBox(height: 10),
                    PredictionDisplay(prediction: prediction), // Custom widget for prediction
                  ],
                ),
              ),
            ),
    );
  }
}

// Widget to display power mode with dynamic color and styling
class PowerModeDisplay extends StatelessWidget {
  final String mode;

  const PowerModeDisplay({required this.mode});

  @override
  Widget build(BuildContext context) {
    final color = mode == "Power Saving" ? Colors.redAccent : Colors.blueAccent;
    return Text(
      "Mode: $mode",
      style: TextStyle(
        fontSize: 22,
        color: color,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

// Widget to display energy prediction with visual feedback
class PredictionDisplay extends StatelessWidget {
  final double? prediction;

  const PredictionDisplay({required this.prediction});

  @override
  Widget build(BuildContext context) {
    final isLasting = prediction == 1;
    final icon = isLasting ? Icons.check_circle : Icons.warning;
    final color = isLasting ? Colors.green : Colors.red;
    final text = isLasting ? "Power will last" : "Power will not last";

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 22,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// Weather information card for displaying weather data
class WeatherInfoCard extends StatelessWidget {
  final String description;
  final double temperature;

  const WeatherInfoCard({
    required this.description,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Pretoria Weather",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 5),
        Text(
          "$description, ${temperature.toStringAsFixed(1)}°C",
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
      ],
    );
  }
}

// Reusable info card widget for displaying temperature and light intensity data
class InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const InfoCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.blueAccent, Colors.lightBlueAccent]),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 36),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
