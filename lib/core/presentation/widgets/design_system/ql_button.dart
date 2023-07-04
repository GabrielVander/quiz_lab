import 'package:flutter/material.dart';

class _QLButton extends StatelessWidget {
  const _QLButton({
    required this.onPressed,
    required this.color,
    required this.hoverColor,
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
  final Color hoverColor;
  final Color pressedColor;
  final Color textColor;
  final Widget child;
  final bool loading;
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
            return hoverColor;
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
    return _QLButton(
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
    return _QLButton(
      onPressed: onPressed,
      color: _defaultColor,
      spacing: spacing,
      hoverColor: _hoverColor,
      pressedColor: _pressedColor,
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
  }) : super._(child: _QLButtonText(text: text));
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
          child: _QLIconButton(
            data: data,
            color: color,
          ),
        );
}

class _QLPrimaryButtonText extends QLPrimaryButton {
  _QLPrimaryButtonText({
    required String text,
    required super.onPressed,
    required super.spacing,
    required super.loading,
    super.key,
  }) : super._(child: _QLButtonText(text: text));
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
          child: _QLIconButton(
            data: data,
            color: color,
          ),
        );
}

enum QLButtonSpacing { defaultSpacing, compactSpacing }
