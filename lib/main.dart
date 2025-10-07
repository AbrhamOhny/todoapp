import 'package:flutter/material.dart';
import 'package:todoapp/controller/pages.dart';
import 'package:todoapp/controller/theme.dart' as app_theme;
import 'package:todoapp/interfaces/user.dart';
import 'package:todoapp/pages/credentials.dart';

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
  void setThemeMode(ThemeMode mode) {
    setState(() {
      currentUser.settings.setFromThemeMode(mode);
      currentUser.saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: app_theme.themeDataLight,
      darkTheme: app_theme.themeDataDark,
      themeMode: currentUser.settings.themeMode,
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
      body: SafeArea(
        child: SingleChildScrollView(child: pages[currentPageIndex]),
      ),
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
    Scaffold loginPage = Scaffold(body: SafeArea(child: LoginPage()));
    return currentUser.id == -1
        ? freshPage
        : currentUser.settings.loginOnStart && !currentUser.isLoggedIn
        ? loginPage
        : defaultPage;
  }
}
