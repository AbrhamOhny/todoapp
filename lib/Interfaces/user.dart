import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:todoapp/Interfaces/task.dart';
import 'package:todoapp/Interfaces/settings.dart';

class User {
  late int id;
  late String username;
  late String password;
  late List<Task> tasks;
  late Settings settings;
  bool isLoggedIn = false;
  final String _userDataFilePath = 'assets/userdata.json';
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
    this.id = 0;
    this.tasks = [];
    this.settings = Settings();
    this.username = username;
    this.password = password;
  }

  Future<void> loadUserData() async {
    // Load user data from a database or API
    // This is a placeholder for actual data loading logic
    String data = await rootBundle.loadString(_userDataFilePath);
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
              id: task['id'] is int ? task['id'] : int.parse(task['id'] ?? '0'),
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
    File file = File(_userDataFilePath);

    String jsonString = jsonEncode(userData);
    await file.writeAsString(jsonString);
    print("User data saved successfully for user $username");
  }
}
