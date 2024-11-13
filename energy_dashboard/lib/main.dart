// path: lib/main.dart

import 'package:flutter/material.dart';
import 'package:energy_dashboard/dashboard_screen.dart';
import 'energy_dashboard_controller.dart';

void main() {
  runApp(EnergyDashboard());
}

class EnergyDashboard extends StatefulWidget {
  @override
  _EnergyDashboardState createState() => _EnergyDashboardState();
}

class _EnergyDashboardState extends State<EnergyDashboard> with SingleTickerProviderStateMixin {
  final EnergyDashboardController _controller = EnergyDashboardController();
  ThemeMode _themeMode = ThemeMode.light;
  late AnimationController _animationController;
  late Animation<double> _fadeIn;
  bool _isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _controller.startPeriodicUpdates(Duration(minutes: 1));
    _loadData(); // Call function to load data initially and set loading state
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _fadeIn = CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    _animationController.forward();
  }

  Future<void> _loadData() async {
    await _controller.updateEnergyData();
    await _controller.updateWeatherData();
    setState(() {
      _isLoading = false; // Disable loading state after data is loaded
    });
  }

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Arduino Power Saver',
      theme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: _themeMode,
      home: DashboardScreen(
        toggleTheme: _toggleTheme,
        themeMode: _themeMode,
        temperature: _controller.temperature,
        lightIntensity: _controller.lightIntensity,
        powerMode: _controller.powerMode,
        prediction: _controller.prediction,
        weatherDescription: _controller.weatherDescription,
        weatherTemperature: _controller.weatherTemperature,
        animation: _fadeIn,
        isLoading: _isLoading, // Pass loading state to DashboardScreen
      ),
    );
  }
}
