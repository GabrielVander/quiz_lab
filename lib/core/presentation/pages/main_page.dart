import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:quiz_lab/core/presentation/widgets/quiz_lab_app_bar.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    const contentPadding = 10.0;

    return SafeArea(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final screenHeight = constraints.constrainHeight();
          final iconSize = lerpDouble(50, screenHeight, 0.02) ?? 50;
          final appBarHeight = iconSize + (contentPadding * 2);

          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(appBarHeight),
              child: QuizLabAppBar(
                leadingIconLeftPadding: contentPadding,
                iconSize: iconSize,
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text(
                    'Hello World!',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
