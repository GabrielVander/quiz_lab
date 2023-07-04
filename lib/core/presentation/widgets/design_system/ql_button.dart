import 'package:flutter/material.dart';

class _QLButton extends StatelessWidget {
  const _QLButton({
    required this.color,
    required this.overlayColor,
    required this.pressedColor,
    required this.textColor,
    required this.loading,
    required QLButtonSpacing spacing,
    required this.child,
  })  : _verticalPadding = spacing == QLButtonSpacing.defaultSpacing ? 6 : 2,
        _loadingIconSize = spacing == QLButtonSpacing.defaultSpacing ? 20 : 16;

  static const double focusedPadding = 2;
  static const Color focusedBorderColor = Color(0xFF388BFF);
  static const double focusedBorderWidth = 2;
  static const double horizontalPadding = 12;
  static const double borderRadius = 3;
  static const Color disabledColor = Color(0xFF091E42);
  static const double disabledBackgroundOpacity = 0.03;
  static const double disabledTextOpacity = 0.31;
  final Color color;
  final Color overlayColor;
  final Color pressedColor;
  final Color textColor;
  final Widget child;
  final bool loading;
  final double _verticalPadding;
  final double _loadingIconSize;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      style: ButtonStyle(
        padding: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.focused)) {
            return EdgeInsets.symmetric(
              horizontal: horizontalPadding + focusedPadding,
              vertical: _verticalPadding + focusedPadding,
            );
          }

          return EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: _verticalPadding);
        }),
        side: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.focused)) {
            return const BorderSide(color: focusedBorderColor, width: focusedBorderWidth);
          }

          return null;
        }),
        overlayColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.hovered)) {
            return overlayColor;
          }

          if (states.contains(MaterialState.pressed)) {
            return pressedColor;
          }

          return null;
        }),
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return disabledColor.withOpacity(disabledBackgroundOpacity);
          }

          return color;
        }),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return disabledColor.withOpacity(disabledTextOpacity);
          }

          return textColor;
        }),
        shape: MaterialStateProperty.resolveWith(
          (states) => const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          ),
        ),
      ),
      child: loading
          ? SizedBox(
              height: _loadingIconSize,
              width: _loadingIconSize,
              child: CircularProgressIndicator(color: textColor, strokeWidth: 2),
            )
          : child,
    );
  }
}

class _QLButtonText extends StatelessWidget {
  const _QLButtonText({required this.text});

  static const double fontSize = 20;
  static const FontWeight fontWeight = FontWeight.w500;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}

class _QLIconButton extends StatelessWidget {
  const _QLIconButton({required this.data, required this.color});

  final IconData data;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Icon(
      data,
      color: color,
    );
  }
}

class QLDefaultButton extends StatelessWidget {
  const QLDefaultButton._({
    required Widget child,
    required this.spacing,
    required this.loading,
    super.key,
  }) : _child = child;

  factory QLDefaultButton.text({
    required String text,
    QLButtonSpacing spacing = QLButtonSpacing.defaultSpacing,
    bool loading = false,
    Key? key,
  }) =>
      _QLDefaultButtonText(
        text: text,
        spacing: spacing,
        loading: loading,
        key: key,
      );

  factory QLDefaultButton.icon({
    required IconData iconData,
    QLButtonSpacing spacing = QLButtonSpacing.defaultSpacing,
    bool loading = false,
    Key? key,
  }) =>
      _QLDefaultIconButton(
        data: iconData,
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
  final Widget _child;
  final QLButtonSpacing spacing;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return _QLButton(
      color: _buttonColor.withOpacity(_defaultColorOpacityPercentage),
      spacing: spacing,
      overlayColor: _buttonColor.withOpacity(_hoverColorOpacityPercentage),
      pressedColor: _buttonColor.withOpacity(_pressedColorOpacityPercentage),
      textColor: _textColor,
      loading: loading,
      child: _child,
    );
  }
}

class _QLDefaultButtonText extends QLDefaultButton {
  _QLDefaultButtonText({
    required String text,
    required super.spacing,
    required super.loading,
    super.key,
  }) : super._(child: _QLButtonText(text: text));
}

class _QLDefaultIconButton extends QLDefaultButton {
  _QLDefaultIconButton({
    required IconData data,
    required Color color,
    required super.spacing,
    required super.loading,
    super.key,
  }) : super._(
          child: _QLIconButton(
            data: data,
            color: color,
          ),
        );
}

enum QLButtonSpacing { defaultSpacing, compactSpacing }
