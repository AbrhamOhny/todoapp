import 'package:flutter/material.dart';
import 'package:todoapp/main.dart';

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

/// RegisterPage ///
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: pagesPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Register', style: Theme.of(context).textTheme.displaySmall),
          Card(
            child: Padding(
              padding: itemsPadding,
              child: Column(
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(labelText: 'Username'),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      currentUser.register(
                        _usernameController.text,
                        _passwordController.text,
                      );
                      currentUser.saveData();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => MainApp()),
                      );
                    },
                    child: Text('Register'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// HomePage ///
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // TODO: handle data
    final activeTasks = currentUser.tasks
        .where((task) => !task.isCompleted)
        .toList();
    final completedTasks = currentUser.tasks
        .where((task) => task.isCompleted)
        .toList();

    return Padding(
      padding: pagesPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome, ${currentUser.username}!',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          Card(
            child: Padding(
              padding: pagesPadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 5,
                    children: [
                      Icon(Icons.table_chart),
                      Text(
                        "Tasks",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Padding(
                    padding: itemsPadding,
                    child: Text('Active Tasks (${activeTasks.length})'),
                  ),
                  Padding(
                    padding: itemsPadding,
                    child: Text('Completed Tasks (${completedTasks.length})'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// TasksPage ///
class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> taskWidgets = currentUser.tasks.map((task) {
      return Card(
        child: ListTile(
          title: Text(task.title),
          subtitle: Text(task.description),
          trailing: Checkbox(
            value: task.isCompleted,
            onChanged: (bool? value) {
              setState(() {
                task.isCompleted = value ?? false;
              });
            },
          ),
        ),
      );
    }).toList();
    return Padding(
      padding: pagesPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: taskWidgets.isNotEmpty
            ? taskWidgets
            : [
                Center(
                  child: Text(
                    'No tasks available',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
      ),
    );
  }
}

/// SettingsPage ///
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void onDropdownValueChanged(int? value) {
    if (value == 0) {
      MainApp.of(context)?.setThemeMode(ThemeMode.light);
    } else if (value == 1) {
      MainApp.of(context)?.setThemeMode(ThemeMode.dark);
    } else if (value == 2) {
      MainApp.of(context)?.setThemeMode(ThemeMode.system);
    }
    setState(() {
      _themeDropdownValue = value ?? 0;
    });
  }

  int getAppliedThemeMode() {
    final themeMode = MainApp.of(context)?.getThemeMode() ?? ThemeMode.system;

    if (themeMode == ThemeMode.light) return 0;
    if (themeMode == ThemeMode.dark) return 1;
    return 2;
  }

  late int _themeDropdownValue;

  @override
  Widget build(BuildContext context) {
    _themeDropdownValue = getAppliedThemeMode();

    return Padding(
      padding: pagesPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: pagesPadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 5,
                    children: [
                      Icon(Icons.brush_outlined),
                      Text(
                        'Theme',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Padding(
                    padding: itemsPadding,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Mode'),
                        DropdownButton(
                          itemHeight: null,
                          items: [
                            DropdownMenuItem(value: 0, child: Text('Light')),
                            DropdownMenuItem(value: 1, child: Text('Dark')),
                            DropdownMenuItem(value: 2, child: Text('System')),
                          ],
                          onChanged: onDropdownValueChanged,
                          value: _themeDropdownValue,
                          dropdownColor: Theme.of(context).colorScheme.surface,
                          underline: Container(height: 0),
                          borderRadius: BorderRadius.circular(8),
                          padding: EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
