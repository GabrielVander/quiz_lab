import 'package:flutter/material.dart';
import 'package:quiz_lab/features/quiz/presentation/widgets/page_subtitle.dart';
import 'package:quiz_lab/features/quiz/presentation/widgets/under_construction.dart';
import 'package:quiz_lab/generated/l10n.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            children: [
              PageSubtitle(title: S.of(context).resultsSectionDisplayName),
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
