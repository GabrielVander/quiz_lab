import 'package:flutter/material.dart';
import 'package:quiz_lab/common/ui/widgets/beta_banner_display.dart';
import 'package:quiz_lab/generated/l10n.dart';

class AnswerAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AnswerAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BetaBannerDisplay(
      child: AppBar(
        title: Text(
          S.of(context).questionAnswerPageTitle,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
