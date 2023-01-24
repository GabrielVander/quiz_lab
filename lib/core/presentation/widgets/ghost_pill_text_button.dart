import 'package:flutter/material.dart';
import 'package:quiz_lab/core/presentation/themes/extensions.dart';

class GhostPillTextButton extends StatelessWidget {
  const GhostPillTextButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.enabled = true,
  });

  final bool enabled;
  final Widget child;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: enabled ? onPressed : null,
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: enabled
              ? Theme.of(context).extension<ThemeColors>()!.mainColors.primary
              : Theme.of(context)
                  .extension<ThemeColors>()!
                  .backgroundColors
                  .disabled,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: enabled
            ? Theme.of(context)
                .extension<ThemeColors>()!
                .mainColors
                .primary
                .withOpacity(0.075)
            : Theme.of(context)
                .extension<ThemeColors>()!
                .backgroundColors
                .disabled
                .withOpacity(0.075),
      ),
      child: child,
    );
  }
}
