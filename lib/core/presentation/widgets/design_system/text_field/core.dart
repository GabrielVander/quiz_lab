import 'package:flutter/material.dart';

class QLTextField extends StatelessWidget {
  const QLTextField._({
    required this.onChanged,
    required this.enabledDefaultBorder,
    required this.enabledFocusedBorder,
    required this.enabledErrorBorder,
    required this.obscureText,
    this.initialValue,
    this.labelText,
    this.placeholderText,
    this.helperText,
    this.errorMessage,
    this.prefixIcon,
    super.key,
  });

  factory QLTextField.standard({
    required void Function(String) onChanged,
    Key? key,
    String? initialValue,
    String? labelText,
    String? placeholderText,
    String? helperText,
    String? errorMessage,
    Widget? prefixIcon,
    bool obscureText = false,
  }) =>
      QLTextField._(
        key: key,
        onChanged: onChanged,
        enabledDefaultBorder: true,
        enabledFocusedBorder: true,
        enabledErrorBorder: true,
        initialValue: initialValue,
        labelText: labelText,
        placeholderText: placeholderText,
        helperText: helperText,
        errorMessage: errorMessage,
        prefixIcon: prefixIcon,
        obscureText: obscureText,
      );

  factory QLTextField.subtle({
    required void Function(String) onChanged,
    Key? key,
    String? initialValue,
    String? labelText,
    String? placeholderText,
    String? helperText,
    String? errorMessage,
    Widget? prefixIcon,
    bool obscureText = false,
  }) =>
      QLTextField._(
        key: key,
        onChanged: onChanged,
        enabledDefaultBorder: false,
        enabledFocusedBorder: true,
        enabledErrorBorder: true,
        initialValue: initialValue,
        labelText: labelText,
        placeholderText: placeholderText,
        helperText: helperText,
        errorMessage: errorMessage,
        prefixIcon: prefixIcon,
        obscureText: obscureText,
      );

  factory QLTextField.none({
    required void Function(String) onChanged,
    Key? key,
    String? initialValue,
    String? labelText,
    String? placeholderText,
    String? helperText,
    String? errorMessage,
    Widget? prefixIcon,
    bool obscureText = false,
  }) =>
      QLTextField._(
        key: key,
        onChanged: onChanged,
        enabledDefaultBorder: false,
        enabledFocusedBorder: false,
        enabledErrorBorder: false,
        initialValue: initialValue,
        labelText: labelText,
        placeholderText: placeholderText,
        helperText: helperText,
        errorMessage: errorMessage,
        prefixIcon: prefixIcon,
        obscureText: obscureText,
      );

  final String? initialValue;
  final String? labelText;
  final String? placeholderText;
  final String? helperText;
  final String? errorMessage;
  final Widget? prefixIcon;
  final bool obscureText;
  final void Function(String) onChanged;
  final bool enabledDefaultBorder;
  final bool enabledFocusedBorder;
  final bool enabledErrorBorder;

  @override
  Widget build(BuildContext context) {
    final defaultColor = const Color(0xFF091E42).withOpacity(.14);
    const focusedColor = Colors.blue;
    const errorColor = Colors.red;

    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: placeholderText,
        helperText: helperText,
        labelText: labelText,
        errorText: errorMessage,
        hoverColor: const Color(0xFFF7F8F9),
        filled: true,
        fillColor: Colors.transparent,
        prefixIcon: prefixIcon,
        prefixIconColor: MaterialStateColor.resolveWith((states) {
          if (states.contains(MaterialState.focused)) {
            return focusedColor;
          }

          if (states.contains(MaterialState.error)) {
            return errorColor;
          }

          return defaultColor;
        }),
        border: MaterialStateOutlineInputBorder.resolveWith((states) {
          final defaultBorderSide = BorderSide(
            color: defaultColor,
            width: 2,
          );

          final defaultBorder = OutlineInputBorder(
            borderRadius: BorderRadius.circular(3),
            borderSide: defaultBorderSide,
          );

          final focusedBorder = defaultBorder.copyWith(
            borderSide: defaultBorderSide.copyWith(
              color: focusedColor,
            ),
          );

          final errorBorder = defaultBorder.copyWith(
            borderSide: defaultBorderSide.copyWith(
              color: errorColor,
            ),
          );

          if (states.contains(MaterialState.focused)) {
            return enabledFocusedBorder ? focusedBorder : InputBorder.none;
          }

          if (states.contains(MaterialState.error)) {
            return enabledErrorBorder ? errorBorder : InputBorder.none;
          }

          return enabledDefaultBorder ? defaultBorder : InputBorder.none;
        }),
      ),
    );
  }
}
