import 'package:flutter/material.dart';
import 'package:quiz_lab/core/presentation/widgets/design_system/button/core.dart';

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
  static const Color _pressedTextColor = Color(0xFF0055CC);
  static const Color _backgroundColor = Colors.transparent;
  final Widget child;
  final bool loading;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return QLButton(
      onPressed: onPressed,
      backgroundColor: _backgroundColor,
      spacing: QLButtonSpacing.defaultSpacing,
      backgroundColorOnHover: _backgroundColor,
      backgroundColorOnPressed: _pressedTextColor,
      textColor: _textColor,
      textColorOnPressed: _pressedTextColor,
      loading: loading,
      showUnderlineOnInteraction: true,
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
  }) : super._(child: QLButtonText(text: text));
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
