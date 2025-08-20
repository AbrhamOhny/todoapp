import 'package:flutter/material.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/Interfaces/task.dart';

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

/// LoginPage ///
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: pagesPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: pagesPadding,
            child: Text(
              'Login',
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ),
          Padding(
            padding: itemsPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              spacing: 15,
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
                Padding(
                  padding: pagesPadding,
                  child: ElevatedButton(
                    onPressed: () {
                      if (currentUser.username == _usernameController.text &&
                          currentUser.password == _passwordController.text) {
                        currentUser.isLoggedIn = true;
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => MainApp()),
                        );
                      } else {
                        // Handle login failure
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Invalid username or password'),
                          ),
                        );
                        return;
                      }
                    },
                    child: Text('Procceed'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: pagesPadding,
            child: Text(
              'Register',
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ),
          Padding(
            padding: itemsPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              spacing: 15,
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
                Padding(
                  padding: pagesPadding,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_usernameController.text.isEmpty ||
                          _passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please fill in all fields')),
                        );
                        return;
                      }
                      currentUser.register(
                        _usernameController.text,
                        _passwordController.text,
                      );
                      currentUser.saveData();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => MainApp()),
                      );
                    },
                    child: Text('Procceed'),
                  ),
                ),
              ],
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
    final List<Widget> taskWidgets = [];
    for (var task in currentUser.tasks) {
      taskWidgets.add(
        Card(
          child: ListTile(
            title: Text(task.title),
            subtitle: Text(task.description),
            trailing: Checkbox(
              value: task.isCompleted,
              onChanged: (bool? value) {
                setState(() {
                  task.isCompleted = value ?? false;
                  currentUser.saveData();
                });
              },
            ),
          ),
        ),
      );
    }
    if (taskWidgets.isEmpty) {
      taskWidgets.insert(
        0,
        Center(
          child: Text(
            'No tasks available',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    }
    taskWidgets.add(
      TextButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskPage()),
          );
          setState(() {});
        },
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          runAlignment: WrapAlignment.center,
          spacing: 5,
          runSpacing: 5,
          children: [
            Icon(Icons.add),
            Text('Add Task', style: TextStyle(letterSpacing: -0.5)),
          ],
        ),
      ),
    );
    return Padding(
      padding: pagesPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: taskWidgets,
      ),
    );
  }
}

/// AddTaskPage ///
class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: pagesPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: pagesPadding,
              child: Text(
                'Add Task',
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
            Padding(
              padding: itemsPadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                spacing: 15,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                  ),
                  Padding(
                    padding: pagesPadding,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_titleController.text.isEmpty ||
                            _descriptionController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please fill in all fields'),
                            ),
                          );
                          return;
                        }
                        final newTask = Task(
                          id: currentUser.tasks.length + 1,
                          title: _titleController.text,
                          description: _descriptionController.text,
                        );
                        setState(() {
                          currentUser.addTask(newTask);
                        });
                        currentUser.saveData();
                        Navigator.pop(context);
                      },
                      child: Text('Add Task'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
  }

  void onSwitchChanged(bool value) {
    setState(() {
      currentUser.settings.loginOnStart = value;
      currentUser.saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                          value: currentUser.settings.preferedThemeMode,
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
                      Icon(Icons.android_outlined),
                      Text(
                        'App Behavior',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Padding(
                    padding: itemsPadding,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Login on start'),
                        Switch(
                          value: currentUser.settings.loginOnStart,
                          onChanged: onSwitchChanged,
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
