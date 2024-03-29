import 'package:flutter/material.dart';
import 'package:quiz_lab/core/presentation/design_system/button/core.dart';

class QLSubtleButton extends StatelessWidget {
  const QLSubtleButton._({
    required this.onPressed,
    required this.child,
    required this.spacing,
    required this.loading,
    super.key,
  });

  factory QLSubtleButton.text({
    required String text,
    void Function()? onPressed,
    QLButtonSpacing spacing = QLButtonSpacing.defaultSpacing,
    bool loading = false,
    Key? key,
  }) =>
      _QLSubtleButtonText(
        text: text,
        onPressed: onPressed,
        spacing: spacing,
        loading: loading,
        key: key,
      );

  factory QLSubtleButton.icon({
    required IconData iconData,
    void Function()? onPressed,
    QLButtonSpacing spacing = QLButtonSpacing.defaultSpacing,
    bool loading = false,
    Key? key,
  }) =>
      _QLSubtleIconButton(
        data: iconData,
        onPressed: onPressed,
        color: _textColor,
        spacing: spacing,
        loading: loading,
        key: key,
      );

  static const Color _textColor = Color(0xFF172B4D);
  static const Color _defaultColor = Colors.transparent;
  static const Color _buttonColor = Color(0xFF091E42);
  static const double _hoverColorOpacityPercentage = .06;
  static const double _pressedColorOpacityPercentage = .14;
  final Widget child;
  final QLButtonSpacing spacing;
  final bool loading;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return QLButton(
      onPressed: onPressed,
      backgroundColor: _defaultColor,
      spacing: spacing,
      backgroundColorOnHover: _buttonColor.withOpacity(_hoverColorOpacityPercentage),
      backgroundColorOnPressed: _buttonColor.withOpacity(_pressedColorOpacityPercentage),
      textColor: _textColor,
      textColorOnPressed: _textColor,
      loading: loading,
      showUnderlineOnInteraction: false,
      child: child,
    );
  }
}

class _QLSubtleButtonText extends QLSubtleButton {
  _QLSubtleButtonText({
    required String text,
    required super.onPressed,
    required super.spacing,
    required super.loading,
    super.key,
  }) : super._(child: QLButtonText(text: text));
}

class _QLSubtleIconButton extends QLSubtleButton {
  _QLSubtleIconButton({
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
