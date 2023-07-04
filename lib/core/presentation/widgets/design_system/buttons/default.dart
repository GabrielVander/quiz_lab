import 'package:flutter/material.dart';
import 'package:quiz_lab/core/presentation/widgets/design_system/buttons/core.dart';

class QLDefaultButton extends StatelessWidget {
  const QLDefaultButton._({
    required this.onPressed,
    required this.child,
    required this.spacing,
    required this.loading,
    super.key,
  });

  factory QLDefaultButton.text({
    required String text,
    void Function()? onPressed,
    QLButtonSpacing spacing = QLButtonSpacing.defaultSpacing,
    bool loading = false,
    Key? key,
  }) =>
      _QLDefaultButtonText(
        text: text,
        onPressed: onPressed,
        spacing: spacing,
        loading: loading,
        key: key,
      );

  factory QLDefaultButton.icon({
    required IconData iconData,
    void Function()? onPressed,
    QLButtonSpacing spacing = QLButtonSpacing.defaultSpacing,
    bool loading = false,
    Key? key,
  }) =>
      _QLDefaultIconButton(
        data: iconData,
        onPressed: onPressed,
        color: _textColor,
        spacing: spacing,
        loading: loading,
        key: key,
      );

  static const Color _textColor = Color(0xFF172B4D);
  static const Color _buttonColor = Color(0xFF091E42);
  static const double _defaultColorOpacityPercentage = .06;
  static const double _hoverColorOpacityPercentage = .14;
  static const double _pressedColorOpacityPercentage = .31;
  final Widget child;
  final QLButtonSpacing spacing;
  final bool loading;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return QLButton(
      onPressed: onPressed,
      color: _buttonColor.withOpacity(_defaultColorOpacityPercentage),
      spacing: spacing,
      hoverColor: _buttonColor.withOpacity(_hoverColorOpacityPercentage),
      pressedColor: _buttonColor.withOpacity(_pressedColorOpacityPercentage),
      textColor: _textColor,
      loading: loading,
      child: child,
    );
  }
}

class _QLDefaultButtonText extends QLDefaultButton {
  _QLDefaultButtonText({
    required String text,
    required super.onPressed,
    required super.spacing,
    required super.loading,
    super.key,
  }) : super._(child: QLButtonText(text: text));
}

class _QLDefaultIconButton extends QLDefaultButton {
  _QLDefaultIconButton({
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
