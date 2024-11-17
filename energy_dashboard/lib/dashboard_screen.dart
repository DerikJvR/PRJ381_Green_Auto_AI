import 'package:flutter/material.dart';
import 'dart:async';
import 'data_service.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final ThemeMode themeMode;

  DashboardScreen({required this.toggleTheme, required this.themeMode});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DataService dataService = DataService();
  Map<String, dynamic>? data;
  Map<String, dynamic>? weatherData;
  bool isLoading = true;
  Timer? periodicTimer;

  @override
  void initState() {
    super.initState();
    fetchData();
    periodicTimer = Timer.periodic(Duration(seconds: 60), (timer) async {
      if (mounted) {
        await fetchData();
      }
    });
  }

  @override
  void dispose() {
    periodicTimer?.cancel();
    super.dispose();
  }

  Future<void> fetchData() async {
    setState(() => isLoading = true);

    try {
      final serverData = await dataService.fetchData();
      final weather = await dataService.fetchWeatherData("Pretoria");
      setState(() {
        data = serverData;
        weatherData = weather;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = widget.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Energy Dashboard',
          style: TextStyle(fontFamily: 'NotoSans'),
        ),
        centerTitle: true,
        actions: [
          Switch(
            value: isDarkMode,
            onChanged: (value) => widget.toggleTheme(),
            activeColor: theme.colorScheme.secondary,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Dashboard Overview",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyLarge?.color,
                      fontFamily: 'NotoSans',
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (weatherData != null)
                    WeatherInfoCard(
                      description: weatherData?["weather"]?[0]["description"] ?? "No Description",
                      temperature: weatherData?["main"]?["temp"]?.toDouble() ?? 0.0,
                    )
                  else
                    Center(
                      child: Text(
                        "Weather data unavailable",
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                    ),
                  const Divider(height: 30, color: Colors.grey),
                  InfoRow(
                    label1: "Temperature",
                    value1: "${data?['temperature'] ?? '--'}°C",
                    icon1: Icons.thermostat,
                    label2: "Light Intensity",
                    value2: "${data?['light_intensity'] ?? '--'} Lux",
                    icon2: Icons.light_mode,
                  ),
                  const SizedBox(height: 20),
                  InfoRow(
                    label1: "Potentiometer Voltage",
                    value1: "${data?['potentiometer_voltage'] ?? '--'} V",
                    icon1: Icons.power,
                    label2: "Solar Panel Voltage",
                    value2: "${data?['solar_panel_voltage'] ?? '--'} V",
                    icon2: Icons.solar_power,
                  ),
                  const Divider(height: 30, color: Colors.grey),
                  Text(
                    "Power Mode: ${calculatePowerMode(data)}",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'NotoSans',
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  String calculatePowerMode(Map<String, dynamic>? data) {
    if (data == null) return "Unknown";
    final potVoltage = data['potentiometer_voltage']?.toDouble() ?? 0.0;
    final solarVoltage = data['solar_panel_voltage']?.toDouble() ?? 0.0;
    return potVoltage > solarVoltage ? "Strained" : "Optimal";
  }
}

class WeatherInfoCard extends StatelessWidget {
  final String description;
  final double temperature;

  const WeatherInfoCard({
    required this.description,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          description,
          style: TextStyle(
            fontSize: 20,
            color: theme.colorScheme.primary,
          ),
        ),
        Text(
          "${temperature.toStringAsFixed(1)} °C",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label1;
  final String value1;
  final IconData icon1;
  final String label2;
  final String value2;
  final IconData icon2;

  const InfoRow({
    required this.label1,
    required this.value1,
    required this.icon1,
    required this.label2,
    required this.value2,
    required this.icon2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InfoCard(label: label1, value: value1, icon: icon1),
        InfoCard(label: label2, value: value2, icon: icon2),
      ],
    );
  }
}

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Ensure Material Icons are used
        Icon(
          icon,
          color: Colors.blue,
          size: 40,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSans', // Only apply font to text
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            color: Colors.grey[800],
            fontFamily: 'NotoSans', // Only apply font to text
          ),
        ),
      ],
    );
  }
}
