// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 1. Add this import for SystemChrome

// Import your router

import 'package:vpc/nav/nav.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 3. Lock the app to landscape mode (both left and right)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const MyApp());
}

/// A simple InheritedWidget to provide ThemeMode down the tree.
/// This matches the ThemeProvider.of(context) call in your main_layout.dart.
class ThemeProvider extends InheritedWidget {
  final ThemeMode themeMode;
  final Function(ThemeMode) changeThemeMode;

  const ThemeProvider({
    super.key,
    required this.themeMode,
    required this.changeThemeMode,
    required super.child,
  });

  static ThemeProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeProvider>();
  }

  @override
  bool updateShouldNotify(ThemeProvider oldWidget) {
    return themeMode != oldWidget.themeMode;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  // Default value
  ThemeMode _themeMode = ThemeMode.system;

  void changeThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      themeMode: _themeMode,
      changeThemeMode: changeThemeMode,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'VCP App',
        
        // --- Theme Setup ---
        themeMode: _themeMode,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple, 
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple, 
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),

        // --- GoRouter Injection ---
        routerConfig: goRouter,
      ),
    );
  }
}