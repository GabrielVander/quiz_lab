import 'package:flutter/material.dart';
import 'package:quiz_lab/core/presentation/widgets/design_system/buttons/core.dart';

class QLDangerButton extends StatelessWidget {
  const QLDangerButton._({
    required this.onPressed,
    required this.child,
    required this.spacing,
    required this.loading,
    super.key,
  });

  factory QLDangerButton.text({
    required String text,
    QLButtonSpacing spacing = QLButtonSpacing.defaultSpacing,
    void Function()? onPressed,
    bool loading = false,
    Key? key,
  }) =>
      _QLDangerButtonText(
        onPressed: onPressed,
        text: text,
        spacing: spacing,
        loading: loading,
        key: key,
      );

  factory QLDangerButton.icon({
    required IconData iconData,
    QLButtonSpacing spacing = QLButtonSpacing.defaultSpacing,
    void Function()? onPressed,
    bool loading = false,
    Key? key,
  }) =>
      _QLDangerIconButton(
        onPressed: onPressed,
        data: iconData,
        color: _textColor,
        spacing: spacing,
        loading: loading,
        key: key,
      );

  static const Color _textColor = Colors.white;
  static const Color _defaultBackgroundColor = Color(0xFFCA3521);
  static const Color _backgroundColorOnHover = Color(0xFFAE2A19);
  static const Color _backgroundColorOnPressed = Color(0xFF601E16);
  final void Function()? onPressed;
  final Widget child;
  final QLButtonSpacing spacing;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return QLButton(
      onPressed: onPressed,
      backgroundColor: _defaultBackgroundColor,
      spacing: spacing,
      backgroundColorOnHover: _backgroundColorOnHover,
      backgroundColorOnPressed: _backgroundColorOnPressed,
      textColor: _textColor,
      textColorOnPressed: _textColor,
      loading: loading,
      showUnderlineOnInteraction: false,
      child: child,
    );
  }
}

class _QLDangerButtonText extends QLDangerButton {
  _QLDangerButtonText({
    required String text,
    required super.onPressed,
    required super.spacing,
    required super.loading,
    super.key,
  }) : super._(child: QLButtonText(text: text));
}

class _QLDangerIconButton extends QLDangerButton {
  _QLDangerIconButton({
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
