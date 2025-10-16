import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/battery_viewmodel.dart';
import 'views/battery_monitor_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BatteryViewModel(),
      child: MaterialApp(
        title: 'Battery Monitor',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF121212),
          colorScheme: ColorScheme.dark(
            primary: Colors.tealAccent,
            secondary: Colors.tealAccent.shade400,
            surface: const Color(0xFF1E1E1E),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1E1E1E),
            elevation: 0,
          ),
          snackBarTheme: SnackBarThemeData(
            backgroundColor: Colors.red.shade700,
            contentTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        home: const BatteryMonitorView(),
      ),
    );
  }
}