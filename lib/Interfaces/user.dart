import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:todoapp/Interfaces/task.dart';
import 'package:todoapp/Interfaces/settings.dart';

class User {
  late int id;
  late String username;
  late String password;
  late List<Task> tasks;
  late Settings settings;

  // User({
  //   required this.id,
  //   required this.username,
  //   required this.password,
  //   List<Task>? tasks,
  //   Settings? settings,
  // }) : tasks = tasks ?? [],
  //      settings = settings ?? Settings();

  User();

  Future<void> loadUserData() async {
    // Load user data from a database or API
    // This is a placeholder for actual data loading logic
    String data = await rootBundle.loadString('assets/userdata.json');
    Map<String, dynamic> jsonResult = jsonDecode(data);
    id = jsonResult['id'] is int
        ? jsonResult['id']
        : int.parse(jsonResult['id'] ?? '0');
    username = jsonResult['username'] ?? '';
    settings = Settings(
      preferedThemeMode: int.parse(jsonResult['preferedThemeMode'] ?? '2'),
    );
    if (jsonResult['tasks'] != null) {
      List<dynamic> taskList = jsonResult['tasks'] as List<dynamic>;
      tasks = taskList
          .map(
            (task) => Task(
              id: task['id'],
              title: task['title'],
              description: task['description'],
              isCompleted: task['completed'],
              createdAt: DateTime.parse(task['date_added']),
            ),
          )
          .toList();
    } else {
      print("No tasks found for user $username");
    }
    print("Loaded successfully for user $username");
  }
}
