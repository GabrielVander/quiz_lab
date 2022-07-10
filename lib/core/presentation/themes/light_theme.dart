import 'package:flutter/material.dart';
import 'package:quiz_lab/core/presentation/themes/extensions.dart';
import 'package:quiz_lab/core/presentation/utils/text_colors.dart';

final ThemeData lightTheme = ThemeData.light().copyWith(
  extensions: <ThemeExtension<dynamic>>[
    ThemeColors(textColors: LightThemeTextColors()),
  ],
);

class LightThemeTextColors implements TextColors {
  @override
  Color get primary => Colors.black;
}
