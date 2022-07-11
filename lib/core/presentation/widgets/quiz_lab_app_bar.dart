import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:quiz_lab/core/assets/images.dart';
import 'package:quiz_lab/core/presentation/themes/extensions.dart';

class QuizLabAppBar extends StatelessWidget {
  const QuizLabAppBar({
    super.key,
    required this.leadingIconSize,
    required this.leadingIconLeftPadding,
  });

  final double leadingIconSize;
  final double leadingIconLeftPadding;

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).extension<ThemeColors>()!;
    final leadingIconWidth = leadingIconSize + leadingIconLeftPadding;
    final appBarHeight = leadingIconSize + 20.0;

    return AppBar(
      key: const ValueKey('appBar'),
      backgroundColor: Theme.of(context).canvasColor,
      elevation: 0,
      toolbarHeight: appBarHeight,
      title: const Text(
        'Quiz Lab',
        key: ValueKey('appBarTitle'),
      ),
      leadingWidth: leadingIconWidth,
      titleTextStyle: TextStyle(
        fontSize: lerpDouble(14, leadingIconSize, 0.4),
        color: themeColors.textColors.primary,
      ),
      centerTitle: true,
      leading: LeadingIcon(
        key: const ValueKey('appBarIcon'),
        iconSize: leadingIconSize,
        leftPadding: leadingIconLeftPadding,
      ),
      actions: const [
        SettingsAction(),
      ],
    );
  }
}

class LeadingIcon extends StatelessWidget {
  const LeadingIcon({
    super.key,
    required this.iconSize,
    required this.leftPadding,
  });

  final double leftPadding;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: leftPadding,
        ),
        Image.asset(
          Images.appIconIconOnly,
          height: iconSize,
          width: iconSize,
          // leadingIconLeftPadding: leadingIconLeftPadding,
          // paladinsIconSize: paladinsIconSize,
        ),
      ],
    );
  }
}

class SettingsAction extends StatelessWidget {
  const SettingsAction({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const ValueKey('appBarSettingsButton'),
      onPressed: () => {},
      icon: Icon(
        Icons.settings,
        color: Theme.of(context).textTheme.titleLarge?.color,
        size: 30,
      ),
    );
  }
}
