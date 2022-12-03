import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import 'fork_lift_message.dart';
import 'page_subtitle.dart';

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
