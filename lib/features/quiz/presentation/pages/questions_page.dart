import 'package:flutter/material.dart';
import 'package:quiz_lab/features/quiz/presentation/widgets/page_sub_title.dart';
import 'package:quiz_lab/features/quiz/presentation/widgets/under_construction.dart';

class QuestionsPage extends StatelessWidget {
  const QuestionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            children: const [
              PageSubTitle(title: 'Questions'),
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Center(
                  child: UnderConstruction(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
