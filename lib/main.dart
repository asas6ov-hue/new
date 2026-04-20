import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/location_provider.dart';
import 'providers/prayer_times_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/setup_wizard_screen.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AlmosalyApp());
}

class AlmosalyApp extends StatelessWidget {
  const AlmosalyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => PrayerTimesProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: MaterialApp(
        title: 'تطبيق المصلي',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          fontFamily: 'Amiri',
          scaffoldBackgroundColor: const Color(0xFFF5F5F5),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF2E7D32),
            foregroundColor: Colors.white,
            elevation: 2,
          ),
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF2E7D32),
            secondary: Color(0xFF4CAF50),
            surface: Colors.white,
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/setup': (context) => const SetupWizardScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}
