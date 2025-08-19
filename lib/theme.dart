import 'package:flutter/material.dart';

ThemeData _themeTemplate(ColorScheme colorScheme) {
  /*
    Colors scheme / seedColor are not used.
    (Using material3 default color instead)
  */
  return ThemeData(useMaterial3: true, brightness: colorScheme.brightness);
}

const seedColor = Colors.green;

final ColorScheme colorSchemeLight = ColorScheme.fromSeed(
  seedColor: seedColor,
  brightness: Brightness.light,
);

final ColorScheme colorSchemeDark = ColorScheme.fromSeed(
  seedColor: seedColor,
  brightness: Brightness.dark,
);

final ThemeData themeDataLight = _themeTemplate(colorSchemeLight);
final ThemeData themeDataDark = _themeTemplate(colorSchemeDark);
