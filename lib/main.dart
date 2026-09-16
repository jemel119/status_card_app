import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const RunMyApp());
}

class RunMyApp extends StatefulWidget {
  const RunMyApp({super.key});

  @override
  State<RunMyApp> createState() => _RunMyAppState();
}

class _RunMyAppState extends State<RunMyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('themeMode');
    setState(() {
      _themeMode = switch (saved) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };
    });
  }

  Future<void> _saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', mode.name);
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
    _saveThemeMode(themeMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Status Card Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: _themeMode,
      home: Scaffold(
        appBar: AppBar(title: const Text('Status Card Demo')),
        // Special Feature 4: whole screen cross-fades together
        body: AnimatedTheme(
          data: Theme.of(context),
          duration: const Duration(milliseconds: 500),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.teal
                      : Colors.blueGrey,
                  child: const Icon(Icons.person, size: 42, color: Colors.white),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Flutter Theme Lab',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: 220,
                  height: 64,
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.teal
                        : Colors.amber,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.circle, size: 12, color: Colors.black87),
                      SizedBox(width: 8),
                      Text('Status: Online', style: TextStyle(fontSize: 16, color: Colors.black)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text('Choose the Theme:', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                Switch(
                  value: _themeMode == ThemeMode.dark,
                  onChanged: (bool isDark) {
                    changeTheme(isDark ? ThemeMode.dark : ThemeMode.light);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}