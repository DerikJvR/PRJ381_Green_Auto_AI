import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

void main() {
  runApp(MyApp());
}

<<<<<<< Updated upstream
class MyApp extends StatefulWidget {
=======
<<<<<<< HEAD
class EnergyDashboard extends StatefulWidget {
  const EnergyDashboard({super.key});

=======
class MyApp extends StatefulWidget {
>>>>>>> 8aefebc5d356e8c026792e14dc1eecd6eaa0e26d
>>>>>>> Stashed changes
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;
<<<<<<< Updated upstream
=======
<<<<<<< HEAD
  late AnimationController _animationController;
  late Animation<double> _fadeIn;
  bool _isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _controller.startPeriodicUpdates(const Duration(seconds: 60)); // Fetch data every 60 seconds
    _loadData();
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _fadeIn = CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    _animationController.forward();
  }

  Future<void> _loadData() async {
    await _controller.updateEnergyData();
    await _controller.updateWeatherData();
    setState(() {
      _isLoading = false;
    });
  }
=======
>>>>>>> 8aefebc5d356e8c026792e14dc1eecd6eaa0e26d
>>>>>>> Stashed changes

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Energy Dashboard',
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.light(
          primary: Colors.blue,
          secondary: const Color.fromARGB(255, 0, 0, 0),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: Colors.lightBlueAccent,
          secondary: Colors.grey,
        ),
      ),
      themeMode: _themeMode,
      home: DashboardScreen(toggleTheme: _toggleTheme, themeMode: _themeMode),
    );
  }
}
