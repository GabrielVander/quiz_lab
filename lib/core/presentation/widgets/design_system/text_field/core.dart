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
    this.textInputAction,
    this.keyboardType,
    this.onSaved,
    this.onFieldSubmitted,
    this.onEditingComplete,
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
    TextInputAction? textInputAction,
    TextInputType? keyboardType,
    bool obscureText = false,
    void Function(String?)? onSaved,
    void Function(String)? onFieldSubmitted,
    void Function()? onEditingComplete,
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
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        onSaved: onSaved,
        onFieldSubmitted: onFieldSubmitted,
        onEditingComplete: onEditingComplete,
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
    TextInputAction? textInputAction,
    TextInputType? keyboardType,
    bool obscureText = false,
    void Function(String?)? onSaved,
    void Function(String)? onFieldSubmitted,
    void Function()? onEditingComplete,
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
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        onSaved: onSaved,
        onFieldSubmitted: onFieldSubmitted,
        onEditingComplete: onEditingComplete,
      );

  factory QLTextField.none({
    required void Function(String) onChanged,
    Key? key,
    String? initialValue,
    String? labelText,
    String? placeholderText,
    String? helperText,
    TextInputType? keyboardType,
    String? errorMessage,
    Widget? prefixIcon,
    TextInputAction? textInputAction,
    void Function(String?)? onSaved,
    void Function(String)? onFieldSubmitted,
    void Function()? onEditingComplete,
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
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        onSaved: onSaved,
        onFieldSubmitted: onFieldSubmitted,
        onEditingComplete: onEditingComplete,
      );

  final String? initialValue;
  final String? labelText;
  final String? placeholderText;
  final String? helperText;
  final String? errorMessage;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final void Function(String?)? onSaved;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onEditingComplete;
  final TextInputAction? textInputAction;
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
      onSaved: onSaved,
      onFieldSubmitted: onFieldSubmitted,
      onEditingComplete: onEditingComplete,
      obscureText: obscureText,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: placeholderText,
        helperText: helperText,
        labelText: labelText,
        errorText: errorMessage,
        hoverColor: const Color(0xFFF7F8F9),
        filled: true,
        fillColor: Colors.transparent,
        prefixIcon: prefixIcon,
        labelStyle: const TextStyle(color: Color(0xFF626F86)),
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
