import 'package:flutter/material.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/pages/home.dart';
import 'package:todoapp/pages/setting.dart';
import 'package:todoapp/pages/task.dart';
/*
  TODO:
  - Implement user registration and login functionality
  - Add persistent storage for user data
  - Improve UI/UX design
*/

/// configuration ///
final EdgeInsets pagesPadding = EdgeInsets.symmetric(
  horizontal: 15.0,
  vertical: 15.0,
);
final EdgeInsets itemsPadding = EdgeInsets.symmetric(
  horizontal: 10.0,
  vertical: 5.0,
);
final cardTitleStyle = TextStyle(
  fontWeight: FontWeight.bold,
  wordSpacing: 0,
  letterSpacing: 0,
);
final textFieldBorderRadius = BorderRadius.circular(10);
List<Widget> pages = [TasksPage(), HomePage(), SettingsPage()];
const List<Widget> navDestinations = [
  NavigationDestination(
    icon: Icon(Icons.task_outlined),
    selectedIcon: Icon(Icons.task),
    label: "Tasks",
  ),
  NavigationDestination(
    selectedIcon: Icon(Icons.home),
    icon: Icon(Icons.home_outlined),
    label: 'Home',
  ),
  NavigationDestination(
    selectedIcon: Icon(Icons.settings),
    icon: Icon(Icons.settings_outlined),
    label: 'Settings',
  ),
];

/// functions ///
void registerHandler(
  BuildContext context,
  TextEditingController username,
  TextEditingController password,
  TextEditingController confirmPassword,
) {
  final int minPassLength = 3;
  if (username.text.isEmpty || password.text.isEmpty) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Please fill in all fields')));
    return;
  }
  if (password.text.length < minPassLength) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Password length must be $minPassLength or higher'),
      ),
    );
    return;
  }
  if (password.text != confirmPassword.text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Password confirmation does not matches')),
    );
    return;
  }
  currentUser.register(username.text, password.text);
  currentUser.saveData();
  Navigator.of(
    context,
  ).pushReplacement(MaterialPageRoute(builder: (context) => MainApp()));
}
