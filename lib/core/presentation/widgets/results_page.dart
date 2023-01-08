import 'package:flutter/material.dart';
import 'package:quiz_lab/core/presentation/widgets/fork_lift_message.dart';
import 'package:quiz_lab/core/presentation/widgets/page_subtitle.dart';
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
              children: [
                Center(
                  child: ForkLiftMessage(
                    message: S.of(context).workInProgressMessage,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
