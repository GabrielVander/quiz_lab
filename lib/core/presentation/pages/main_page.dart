import 'package:flutter/material.dart';
import 'package:quiz_lab/core/presentation/widgets/quiz_lab_app_bar.dart';
import 'package:sizer/sizer.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final screenHeight = constraints.constrainHeight();

          return Scaffold(
            appBar: QuizLabAppBar(
              key: const ValueKey<String>('quizLabAppBar'),
              padding: const EdgeInsets.all(10),
              height: 10.h,
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
