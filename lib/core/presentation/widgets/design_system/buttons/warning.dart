import 'package:flutter/material.dart';
import 'package:quiz_lab/core/presentation/widgets/design_system/buttons/core.dart';

class QLWarningButton extends StatelessWidget {
  const QLWarningButton._({
    required this.onPressed,
    required this.child,
    required this.spacing,
    required this.loading,
    super.key,
  });

  factory QLWarningButton.text({
    required String text,
    QLButtonSpacing spacing = QLButtonSpacing.defaultSpacing,
    void Function()? onPressed,
    bool loading = false,
    Key? key,
  }) =>
      _QLWarningButtonText(
        onPressed: onPressed,
        text: text,
        spacing: spacing,
        loading: loading,
        key: key,
      );

  factory QLWarningButton.icon({
    required IconData iconData,
    QLButtonSpacing spacing = QLButtonSpacing.defaultSpacing,
    void Function()? onPressed,
    bool loading = false,
    Key? key,
  }) =>
      _QLWarningIconButton(
        onPressed: onPressed,
        data: iconData,
        color: _textColor,
        spacing: spacing,
        loading: loading,
        key: key,
      );

  static const Color _textColor = Colors.white;
  static const Color _defaultBackgroundColor = Color(0xFFE2B203);
  static const Color _backgroundColorOnHover = Color(0xFFCF9F02);
  static const Color _backgroundColorOnPressed = Color(0xFFB38600);
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

class _QLWarningButtonText extends QLWarningButton {
  _QLWarningButtonText({
    required String text,
    required super.onPressed,
    required super.spacing,
    required super.loading,
    super.key,
  }) : super._(child: QLButtonText(text: text));
}

class _QLWarningIconButton extends QLWarningButton {
  _QLWarningIconButton({
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
