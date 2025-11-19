import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transcriber_app/views/paraphrase_view.dart';
import 'views/premium_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final stored = prefs.getString('themeMode') ?? 'system';
  ThemeMode initialMode;
  switch (stored) {
    case 'light':
      initialMode = ThemeMode.light;
      break;
    case 'dark':
      initialMode = ThemeMode.dark;
      break;
    default:
      initialMode = ThemeMode.system;
  }

  runApp(App(initialThemeMode: initialMode));
}

class App extends StatelessWidget {
  final ThemeMode initialThemeMode;
  const App({super.key, required this.initialThemeMode});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Transcriber App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        primaryColor: const Color(0xFF00C896),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F1425),
        primaryColor: const Color(0xFF00C896),
      ),
      themeMode: initialThemeMode,
      home:  ParaphraseView(),
    );
  }
}
