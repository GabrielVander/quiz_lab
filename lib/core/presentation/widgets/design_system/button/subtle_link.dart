import 'package:flutter/material.dart';
import 'package:quiz_lab/core/presentation/widgets/design_system/button/core.dart';

class QLSubtleLinkButton extends StatelessWidget {
  const QLSubtleLinkButton._({
    required this.onPressed,
    required this.child,
    required this.loading,
    super.key,
  });

  factory QLSubtleLinkButton.text({
    required String text,
    void Function()? onPressed,
    bool loading = false,
    Key? key,
  }) =>
      _QLSubtleLinkButtonText(
        text: text,
        onPressed: onPressed,
        loading: loading,
        key: key,
      );

  factory QLSubtleLinkButton.icon({
    required IconData iconData,
    void Function()? onPressed,
    bool loading = false,
    Key? key,
  }) =>
      _QLSubtleLinkIconButton(
        data: iconData,
        onPressed: onPressed,
        color: _textColor,
        loading: loading,
        key: key,
      );

  static const Color _textColor = Color(0xFF44546F);
  static const Color _defaultColor = Colors.transparent;
  static const Color _pressedTextColor = Color(0xFF172B4D);
  final Widget child;
  final bool loading;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return QLButton(
      onPressed: onPressed,
      backgroundColor: _defaultColor,
      spacing: QLButtonSpacing.defaultSpacing,
      backgroundColorOnHover: _defaultColor,
      backgroundColorOnPressed: _pressedTextColor,
      textColor: _textColor,
      textColorOnPressed: _pressedTextColor,
      loading: loading,
      showUnderlineOnInteraction: true,
      child: child,
    );
  }
}

class _QLSubtleLinkButtonText extends QLSubtleLinkButton {
  _QLSubtleLinkButtonText({
    required String text,
    required super.onPressed,
    required super.loading,
    super.key,
  }) : super._(child: QLButtonText(text: text));
}

class _QLSubtleLinkIconButton extends QLSubtleLinkButton {
  _QLSubtleLinkIconButton({
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
