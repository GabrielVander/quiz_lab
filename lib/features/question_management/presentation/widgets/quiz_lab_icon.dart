import 'package:flutter/material.dart';
import 'package:quiz_lab/core/assets/images.dart';

class QuizLabIcon extends StatelessWidget {
  const QuizLabIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Images.appIconIconOnly,
      fit: BoxFit.scaleDown,
    );
  }
}
