import 'package:flutter/material.dart';

import 'colors.dart';
import 'extensions.dart';

final ThemeData lightTheme = ThemeData.light().copyWith(
  extensions: <ThemeExtension<dynamic>>[
    ThemeColors(
      textColors: LightThemeTextColors(),
      backgroundColors: LightThemeBackgroundColors(),
      mainColors: LightMainColors(),
      difficultyColors: LightDifficultyColors(),
    ),
  ],
);

class LightThemeTextColors implements TextColors {
  @override
  Color get primary => Colors.black;

  @override
  Color get secondary => Colors.white;
}

class LightThemeBackgroundColors implements BackgroundColors {
  @override
  Color get primary => const Color(0xFFFFFFFF);

  @override
  Color get secondary => const Color(0xFF48A7F8);

  @override
  Color get tertiary => const Color(0xFFD9F3FF);
}

class LightMainColors implements MainColors {
  @override
  Color get accent => const Color(0xFF837AD9);

  @override
  Color get primary => const Color(0xFF00C3FE);

  @override
  Color get secondary => const Color(0xFF6791EC);
}

class LightDifficultyColors implements DifficultyColors {
  @override
  Color get easy => const Color(0xFF006C04);

  @override
  Color get hard => const Color(0xFF6C0000);

  @override
  Color get medium => const Color(0xFF00326C);
}
