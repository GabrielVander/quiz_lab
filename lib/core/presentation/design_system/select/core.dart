import 'package:flutter/material.dart';

class QLSelect<T> extends StatelessWidget {
  const QLSelect._({
    required this.onChanged,
    this.initialValue,
    this.labelText,
    this.placeholderText,
    this.helperText,
    this.errorMessage,
    this.prefixIcon,
    this.items,
    super.key,
  });

  factory QLSelect.standard({
    required void Function(T?) onChanged,
    Key? key,
    String? initialValue,
    String? labelText,
    String? placeholderText,
    String? helperText,
    String? errorMessage,
    Widget? prefixIcon,
    List<DropdownMenuItem<T>>? items,
  }) =>
      QLSelect._(
        key: key,
        onChanged: onChanged,
        initialValue: initialValue,
        labelText: labelText,
        placeholderText: placeholderText,
        helperText: helperText,
        errorMessage: errorMessage,
        prefixIcon: prefixIcon,
        items: items,
      );

  final String? initialValue;
  final String? labelText;
  final String? placeholderText;
  final String? helperText;
  final String? errorMessage;
  final Widget? prefixIcon;
  final void Function(T?) onChanged;
  final List<DropdownMenuItem<T>>? items;

  @override
  Widget build(BuildContext context) {
    final defaultColor = const Color(0xFF091E42).withOpacity(.14);
    const focusedColor = Colors.blue;
    const errorColor = Colors.red;

    return DropdownButtonFormField<T>(
      onChanged: onChanged,
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
            return focusedBorder;
          }

          if (states.contains(MaterialState.error)) {
            return errorBorder;
          }

          return defaultBorder;
        }),
      ),
      items: items,
    );
  }
}
