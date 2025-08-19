import 'package:flutter/material.dart';
import 'package:todoapp/pages.dart';
import 'package:todoapp/theme.dart' as app_theme;
import 'package:todoapp/Interfaces/user.dart';

final User currentUser = User();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await currentUser.loadUserData();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  static _MainAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MainAppState>();

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  ThemeMode _themeMode = ThemeMode.system;
  void setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  ThemeMode getThemeMode() {
    return _themeMode;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: app_theme.themeDataLight,
      darkTheme: app_theme.themeDataDark,
      themeMode: _themeMode,
      home: NavigationHandler(),
    );
  }
}

class NavigationHandler extends StatefulWidget {
  const NavigationHandler({super.key});

  @override
  State<NavigationHandler> createState() => _NavigationHandlerState();
}

class _NavigationHandlerState extends State<NavigationHandler> {
  int currentPageIndex = 1;

  @override
  Widget build(BuildContext context) {
    Scaffold defaultPage = Scaffold(
      body: SafeArea(child: pages[currentPageIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: navDestinations,
      ),
    );
    Scaffold freshPage = Scaffold(body: SafeArea(child: RegisterPage()));
    return currentUser.id == -1 ? freshPage : defaultPage;
  }
}
