import 'package:flutter/material.dart';

class QLButton extends StatelessWidget {
  const QLButton({
    required this.onPressed,
    required this.backgroundColor,
    required this.backgroundColorOnHover,
    required this.backgroundColorOnPressed,
    required this.textColor,
    required this.textColorOnPressed,
    required this.loading,
    required this.showUnderlineOnInteraction,
    required QLButtonSpacing spacing,
    required this.child,
    super.key,
  })  : _verticalPadding = spacing == QLButtonSpacing.defaultSpacing ? 6 : 2,
        _loadingIconSize = spacing == QLButtonSpacing.defaultSpacing ? 20 : 16;

  static const double focusedPadding = 2;
  static const Color focusedBorderColor = Color(0xFF388BFF);
  static const double focusedBorderWidth = 2;
  static const double horizontalPadding = 12;
  static const double borderRadius = 3;
  static const Color disabledBaseColor = Color(0xFF091E42);
  static const double disabledBackgroundOpacity = 0.03;
  static const double disabledTextOpacity = 0.31;
  final Color backgroundColor;
  final Color backgroundColorOnHover;
  final Color backgroundColorOnPressed;
  final Color textColor;
  final Color textColorOnPressed;
  final Widget child;
  final bool loading;
  final bool showUnderlineOnInteraction;
  final void Function()? onPressed;
  final double _verticalPadding;
  final double _loadingIconSize;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
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
            return backgroundColorOnHover;
          }

          if (states.contains(MaterialState.pressed)) {
            return backgroundColorOnPressed;
          }

          return null;
        }),
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return disabledBaseColor.withOpacity(disabledBackgroundOpacity);
          }

          return backgroundColor;
        }),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return disabledBaseColor.withOpacity(disabledTextOpacity);
          }

          if (states.contains(MaterialState.pressed)) {
            return textColorOnPressed;
          }

          return textColor;
        }),
        shape: MaterialStateProperty.resolveWith(
          (states) => const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          ),
        ),
        textStyle: MaterialStateProperty.resolveWith(
          (states) {
            const baseTextStyle = TextStyle(
              fontSize: QLButtonText.fontSize,
              fontWeight: QLButtonText.fontWeight,
            );

            if (states.contains(MaterialState.hovered) && showUnderlineOnInteraction) {
              return baseTextStyle.copyWith(decoration: TextDecoration.underline);
            }

            if (states.contains(MaterialState.pressed) && showUnderlineOnInteraction) {
              return baseTextStyle.copyWith(decoration: TextDecoration.underline);
            }

            return baseTextStyle;
          },
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

class QLButtonText extends StatelessWidget {
  const QLButtonText({required this.text, super.key});

  static const double fontSize = 14;
  static const FontWeight fontWeight = FontWeight.w500;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text);
  }
}

class QLIconButton extends StatelessWidget {
  const QLIconButton({required this.data, required this.color, super.key});

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

enum QLButtonSpacing { defaultSpacing, compactSpacing }
