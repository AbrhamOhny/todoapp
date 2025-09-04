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
  final int _minPassLength = 3;
  if (username.text.isEmpty || password.text.isEmpty) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Please fill in all fields')));
    return;
  }
  if (password.text.length < _minPassLength) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Password length must be $_minPassLength or higher'),
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

/// ResetCredentialsPage ///
class ResetCredentialsPage extends StatefulWidget {
  const ResetCredentialsPage({super.key});

  @override
  State<ResetCredentialsPage> createState() => _ResetCredentialsState();
}

class _ResetCredentialsState extends State<ResetCredentialsPage> {
  int pageIndex = 0;
  late Widget confirmationPage;
  late Widget mainPage;
  late List<Widget> pageController;

  @override
  Widget build(BuildContext context) {
    confirmationPage = Padding(
      padding: pagesPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 15,
        children: [
          Text(
            "By resetting your credentials, will result in wiping out currently saved data. Do you want to continue?",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          TextButton(
            onPressed: () => {
              setState(() {
                pageIndex = 1;
              }),
            },
            child: Text("Continue"),
          ),
          TextButton(
            onPressed: () => {Navigator.of(context).pop()},
            child: Text("Cancel"),
          ),
        ],
      ),
    );
    mainPage = Padding(
      padding: pagesPadding,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          spacing: 15,
          children: [
            Text("Reset successful!"),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  currentUser.reset();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => NavigationHandler(),
                    ),
                  );
                },
                child: Text(
                  "Back to register page",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    pageController = [confirmationPage, mainPage];
    return Scaffold(body: pageController[pageIndex]);
  }
}

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
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: textFieldBorderRadius,
                    ),
                  ),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: textFieldBorderRadius,
                    ),
                    counter: Wrap(
                      children: [
                        Text("Forgot your credentials? "),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ResetCredentialsPage(),
                                ),
                              );
                            },
                            child: Text(
                              "click here",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: textFieldBorderRadius,
                    ),
                  ),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: textFieldBorderRadius,
                    ),
                  ),
                  obscureText: true,
                ),
                TextField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: textFieldBorderRadius,
                    ),
                  ),
                  obscureText: true,
                ),
                Padding(
                  padding: pagesPadding,
                  child: ElevatedButton(
                    onPressed: () {
                      registerHandler(
                        context,
                        _usernameController,
                        _passwordController,
                        _confirmPasswordController,
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
        spacing: 5,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Welcome, ${currentUser.username}!',
            style: Theme.of(context).textTheme.titleLarge,
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
                      Text("Tasks", style: cardTitleStyle),
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
    List<int> tasksToDelete = [];
    for (var task in currentUser.tasks) {
      if (task.isCompleted && currentUser.settings.deleteTaskOnComplete) {
        tasksToDelete.add(task.id);
      }
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
                  if (currentUser.settings.deleteTaskOnComplete) {
                    currentUser.deleteTask(task.id);
                  }
                  currentUser.saveData();
                });
              },
            ),
          ),
        ),
      );
    }
    // Delete tasks after iteration
    for (var id in tasksToDelete) {
      currentUser.deleteTask(id);
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
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                        borderRadius: textFieldBorderRadius,
                      ),
                    ),
                  ),
                  TextField(
                    controller: _descriptionController,
                    minLines: 3,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                        borderRadius: textFieldBorderRadius,
                      ),
                    ),
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
                      child: Text('Confirm'),
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

  void onSwitchLoginChanged(bool value) {
    setState(() {
      currentUser.settings.loginOnStart = value;
      currentUser.saveData();
    });
  }

  void onSwitchTaskCompleteChanged(bool value) {
    setState(() {
      currentUser.settings.deleteTaskOnComplete = value;
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
                      Text('Theme', style: cardTitleStyle),
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
                      Text('App Behavior', style: cardTitleStyle),
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
                          onChanged: onSwitchLoginChanged,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: itemsPadding,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Delete task on complete'),
                        Switch(
                          value: currentUser.settings.deleteTaskOnComplete,
                          onChanged: onSwitchTaskCompleteChanged,
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
