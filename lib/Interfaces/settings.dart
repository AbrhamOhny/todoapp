import 'package:flutter/material.dart';

class Settings {
  late int preferedThemeMode;
  late bool loginOnStart;
  late bool deleteTaskOnComplete;
  late ThemeMode themeMode;

  Settings({
    this.preferedThemeMode = 2,
    this.loginOnStart = false,
    this.deleteTaskOnComplete = false,
  }) {
    setFromInt(preferedThemeMode);
  }

  Map<String, dynamic> toJson() {
    return {
      'preferedThemeMode': preferedThemeMode.toString(),
      'loginOnStart': loginOnStart,
      'deleteTaskOnComplete': deleteTaskOnComplete,
    };
  }

  void setFromThemeMode(ThemeMode mode) {
    if (mode == ThemeMode.light) {
      preferedThemeMode = 0;
    } else if (mode == ThemeMode.dark) {
      preferedThemeMode = 1;
    } else {
      preferedThemeMode = 2;
    }
    themeMode = mode;
  }

  void setFromInt(int mode) {
    if (mode == 0) {
      setFromThemeMode(ThemeMode.light);
    } else if (mode == 1) {
      setFromThemeMode(ThemeMode.dark);
    } else {
      setFromThemeMode(ThemeMode.system);
    }
  }
}
