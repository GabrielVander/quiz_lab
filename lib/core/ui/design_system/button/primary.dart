import 'package:flutter/material.dart';
import 'package:quiz_lab/core/ui/design_system/button/core.dart';

class QLPrimaryButton extends StatelessWidget {
  const QLPrimaryButton._({
    required this.onPressed,
    required this.child,
    required this.spacing,
    required this.loading,
    super.key,
  });

  factory QLPrimaryButton.text({
    required String text,
    QLButtonSpacing spacing = QLButtonSpacing.defaultSpacing,
    void Function()? onPressed,
    bool loading = false,
    Key? key,
  }) =>
      _QLPrimaryButtonText(
        onPressed: onPressed,
        text: text,
        spacing: spacing,
        loading: loading,
        key: key,
      );

  factory QLPrimaryButton.icon({
    required IconData iconData,
    QLButtonSpacing spacing = QLButtonSpacing.defaultSpacing,
    void Function()? onPressed,
    bool loading = false,
    Key? key,
  }) =>
      _QLPrimaryIconButton(
        onPressed: onPressed,
        data: iconData,
        color: _textColor,
        spacing: spacing,
        loading: loading,
        key: key,
      );

  static const Color _textColor = Colors.white;
  static const Color _defaultColor = Color(0xFF0C66E4);
  static const Color _hoverColor = Color(0xFF0055CC);
  static const Color _pressedColor = Color(0xFF09326C);
  final void Function()? onPressed;
  final Widget child;
  final QLButtonSpacing spacing;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return QLButton(
      onPressed: onPressed,
      backgroundColor: _defaultColor,
      spacing: spacing,
      backgroundColorOnHover: _hoverColor,
      backgroundColorOnPressed: _pressedColor,
      textColor: _textColor,
      textColorOnPressed: _textColor,
      loading: loading,
      showUnderlineOnInteraction: false,
      child: child,
    );
  }
}

class _QLPrimaryButtonText extends QLPrimaryButton {
  _QLPrimaryButtonText({
    required String text,
    required super.onPressed,
    required super.spacing,
    required super.loading,
    super.key,
  }) : super._(child: QLButtonText(text: text));
}

class _QLPrimaryIconButton extends QLPrimaryButton {
  _QLPrimaryIconButton({
    required IconData data,
    required Color color,
    required super.onPressed,
    required super.spacing,
    required super.loading,
    super.key,
  }) : super._(
          child: QLIconButton(
            data: data,
            color: color,
          ),
        );
}
