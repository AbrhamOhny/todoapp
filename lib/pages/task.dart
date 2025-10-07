import 'package:flutter/material.dart';
import 'package:todoapp/controller/pages.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/interfaces/task.dart';

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
      if (task.isCompleted && currentUser.settings.hideTaskOnComplete) {
        continue;
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
                  task.complete();
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      spacing: 15,
                      children: [
                        ElevatedButton(
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
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                      ],
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
