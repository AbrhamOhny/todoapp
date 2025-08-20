import 'dart:convert';
import 'dart:io';
import 'package:todoapp/Interfaces/task.dart';
import 'package:todoapp/Interfaces/settings.dart';
import 'package:path_provider/path_provider.dart';

class User {
  late int id;
  late String username;
  late String password;
  late List<Task> tasks;
  late Settings settings;
  bool isLoggedIn = false;
  // User({
  //   required this.id,
  //   required this.username,
  //   required this.password,
  //   List<Task>? tasks,
  //   Settings? settings,
  // }) : tasks = tasks ?? [],
  //      settings = settings ?? Settings();

  User();

  void register(String username, String password) {
    id = 0;
    tasks = [];
    settings = Settings();
    this.username = username;
    this.password = password;
  }

  Future<File> _getUserDataFile() async {
    Directory docs;

    if (Platform.isWindows) {
      // Windows: C:\Users\<user>\Documents
      docs = Directory(
        "${Platform.environment['USERPROFILE']}\\Documents\\todoapp",
      );
    } else if (Platform.isMacOS || Platform.isLinux) {
      // macOS/Linux: /home/<user>/Documents or /Users/<user>/Documents
      final home = Platform.environment['HOME']!;
      docs = Directory("$home/Documents/todoapp");
    } else {
      // Android/iOS don’t have a "Documents" folder in the same sense
      // -> fall back to app documents directory, then append /todoapp
      final base = await getApplicationDocumentsDirectory();
      docs = Directory("${base.path}/todoapp");
    }

    // Ensure the folder exists
    if (!(await docs.exists())) {
      await docs.create(recursive: true);
    }

    return File('${docs.path}/userdata.json');
  }

  Future<void> loadUserData() async {
    // Load user data from a database or API
    // This is a placeholder for actual data loading logic
    final file = await _getUserDataFile();
    if (await file.exists()) {
      String data = await file.readAsString();
      Map<String, dynamic> jsonResult = jsonDecode(data);
      id = jsonResult['id'] is int
          ? jsonResult['id']
          : int.parse(jsonResult['id'] ?? '0');
      username = jsonResult['username'] ?? '';
      password = jsonResult['password'] ?? '';
      settings = Settings(
        preferedThemeMode: int.parse(
          jsonResult['settings']?['preferedThemeMode'] ?? '2',
        ),
        loginOnStart: jsonResult['settings']?['loginOnStart'] ?? false,
      );
      if (jsonResult['tasks'] != null) {
        List<dynamic> taskList = jsonResult['tasks'] as List<dynamic>;
        // may need to check if tasklist is empty
        tasks = taskList
            .map(
              (task) => Task(
                id: task['id'] is int
                    ? task['id']
                    : int.parse(task['id'] ?? '0'),
                title: task['title'],
                description: task['description'],
                isCompleted: task['completed'] is bool
                    ? task['completed']
                    : task['completed'] == 'true',
                createdAt: DateTime.parse(task['date_added']),
              ),
            )
            .toList();
      } else {
        print("No tasks found for user $username");
      }
      print("Loaded successfully for user $username");
    } else {
      print("No user data file found. Creating a new user.");
      id = -1;
      settings = Settings();
      tasks = [];
      // proceed to register
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'preferedThemeMode': settings.preferedThemeMode.toString(),
      'tasks': tasks.map((task) => task.toJson()).toList(),
      'settings': settings.toJson(),
    };
  }

  Future<void> saveData() async {
    Map<String, dynamic> userData = {
      'id': id,
      'username': username,
      'password': password,
      'preferedThemeMode': settings.preferedThemeMode.toString(),
      'tasks': tasks.map((task) => task.toJson()).toList(),
      'settings': settings.toJson(),
    };

    final file = await _getUserDataFile();
    String jsonString = jsonEncode(userData);
    await file.writeAsString(jsonString);
    print("User data saved successfully for user $username on ${file.path}");
  }

  addTask(Task task) {
    tasks.add(task);
    saveData();
  }
}
