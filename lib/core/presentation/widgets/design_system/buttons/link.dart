import 'package:flutter/material.dart';
import 'package:quiz_lab/core/presentation/widgets/design_system/buttons/core.dart';

class QLLinkButton extends StatelessWidget {
  const QLLinkButton._({
    required this.onPressed,
    required this.child,
    required this.loading,
    super.key,
  });

  factory QLLinkButton.text({
    required String text,
    void Function()? onPressed,
    bool loading = false,
    Key? key,
  }) =>
      _QLLinkButtonText(
        text: text,
        onPressed: onPressed,
        loading: loading,
        key: key,
      );

  factory QLLinkButton.icon({
    required IconData iconData,
    void Function()? onPressed,
    bool loading = false,
    Key? key,
  }) =>
      _QLLinkIconButton(
        data: iconData,
        onPressed: onPressed,
        color: _textColor,
        loading: loading,
        key: key,
      );

  static const Color _textColor = Color(0xFF0C66E4);
  static const Color _defaultColor = Colors.transparent;
  static const Color _pressedColor = Color(0xFF0055CC);
  final Widget child;
  final bool loading;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return QLButton(
      onPressed: onPressed,
      color: _defaultColor,
      spacing: QLButtonSpacing.defaultSpacing,
      hoverColor: _defaultColor,
      pressedColor: _pressedColor,
      textColor: _textColor,
      loading: loading,
      child: child,
    );
  }
}

class _QLLinkButtonText extends QLLinkButton {
  _QLLinkButtonText({
    required String text,
    required super.onPressed,
    required super.loading,
    super.key,
  }) : super._(
          child: QLButtonText(
            text: text,
            underlineOnHover: true,
          ),
        );
}

class _QLLinkIconButton extends QLLinkButton {
  _QLLinkIconButton({
    required IconData data,
    required Color color,
    required super.onPressed,
    required super.loading,
    super.key,
  }) : super._(
          child: QLIconButton(
            data: data,
            color: color,
          ),
        );
}
