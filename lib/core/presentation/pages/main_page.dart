import 'package:flutter/material.dart';
import 'package:quiz_lab/core/presentation/widgets/quiz_lab_app_bar.dart';
import 'package:responsive_builder/responsive_builder.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final appBarHeight = getValueForScreenType<double>(
            context: context,
            mobile: 75,
            tablet: 90,
            desktop: 100,
          );

          return Scaffold(
            appBar: QuizLabAppBar(
              key: const ValueKey<String>('quizLabAppBar'),
              padding: const EdgeInsets.all(10),
              height: appBarHeight,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text('Hello World!'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
