import 'package:flutter/material.dart';
import 'package:quiz_lab/core/themes/background_colors.dart';
import 'package:quiz_lab/core/themes/extensions.dart';
import 'package:quiz_lab/core/themes/text_colors.dart';

final ThemeData lightTheme = ThemeData.light().copyWith(
  extensions: <ThemeExtension<dynamic>>[
    ThemeColors(
      textColors: LightThemeTextColors(),
      backgroundColors: LightThemeBackgroundColors(),
    ),
  ],
);

class LightThemeTextColors implements TextColors {
  @override
  Color get primary => Colors.black;
}

class LightThemeBackgroundColors implements BackgroundColors {
  @override
  Color get primary => const Color(0xffFFFFFF);

  @override
  Color get secondary => const Color(0xff48A7F8);

  @override
  Color get tertiary => const Color(0xffD9F3FF);
}
