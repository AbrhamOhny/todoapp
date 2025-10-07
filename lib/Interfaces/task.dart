import 'dart:collection';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Task {
  late int id;
  late String title;
  late String description;
  late bool isCompleted;
  late DateTime createdAt;
  late DateTime? completedAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    DateTime? createdAt,
    this.completedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  void complete() {
    isCompleted = true;
    DateTime now = DateUtils.dateOnly(DateTime.now());
    completedAt = now;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'completed': isCompleted,
    'date_added': createdAt.toIso8601String(),
    if (completedAt != null) 'date_completed': completedAt!.toIso8601String(),
  };
}

class TasksList extends ListBase<Task> {
  final List<Task> _tasks = [];

  TasksList(List<Task>? tasks) {
    if (tasks != null) _tasks.addAll(tasks);
  }

  @override
  void add(Task element) {
    _tasks.add(element);
  }

  @override
  int get length => _tasks.length;

  @override
  set length(int newLength) {
    _tasks.length = newLength;
  }

  @override
  Task operator [](int index) => _tasks[index];

  @override
  void operator []=(int index, Task value) => _tasks[index] = value;

  List<Task> get completedTasks =>
      _tasks.where((task) => task.isCompleted).toList();

  List<Task> get activeTasks =>
      _tasks.where((task) => !task.isCompleted).toList();

  // For TableCharts
  Map<String, int> get completedTasksData {
    final Map<String, int> completedTasksData = {};

    for (final task in completedTasks) {
      // ✅ Remove redundant .where()
      if (task.completedAt == null) continue;

      final dateKey =
          "${task.completedAt!.day.toString().padLeft(2, '0')}-"
          "${task.completedAt!.month.toString().padLeft(2, '0')}-"
          "${task.completedAt!.year}";

      completedTasksData.update(
        dateKey,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
    }
    return completedTasksData;
  }

  String? getOldestDate() {
    if (completedTasksData.isEmpty) return null;

    final sortedKeys = completedTasksData.keys.toList()..sort();
    return sortedKeys.first;
  }

  List<FlSpot> get chartSpots {
    if (completedTasksData.isEmpty) return [];
    final sortedEntries = completedTasksData.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final userSpots = List.generate(
      sortedEntries.length,
      (index) => FlSpot(
        index.toDouble(), // x-axis: 0, 1, 2, 3...
        sortedEntries[index].value.toDouble(), // y-axis: task count
      ),
    );
    if (userSpots.length < 3) {
      final List<FlSpot> spots = [];
      spots.add(FlSpot(-1, 0));
      spots.addAll(userSpots);
      return spots;
    } else {
      return userSpots;
    }
  }
}
