import 'package:flutter/material.dart';

class QuestionDescription extends StatelessWidget {
  const QuestionDescription({required this.value, super.key});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: SingleChildScrollView(
        child: Text(
          value,
          overflow: TextOverflow.fade,
          style: Theme.of(context).textTheme.bodyLarge,
          // textScaleFactor: 1.5,
        ),
      ),
    );
  }
}
