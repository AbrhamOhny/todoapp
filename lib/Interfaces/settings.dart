class Settings {
  late int preferedThemeMode;

  Settings({this.preferedThemeMode = 2});

  Map<String, dynamic> toJson() {
    return {'preferedThemeMode': preferedThemeMode.toString()};
  }
}
