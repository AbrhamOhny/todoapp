import 'package:flutter/material.dart';
import 'package:todoapp/controller/pages.dart';
import 'package:todoapp/main.dart';

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
      currentUser.settings.hideTaskOnComplete = value;
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
                        Text('Hide completed task'),
                        Switch(
                          value: currentUser.settings.hideTaskOnComplete,
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
