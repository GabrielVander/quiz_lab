import 'package:flutter/material.dart';
import 'package:quiz_lab/core/presentation/themes/light_theme.dart';

class QLCheckbox extends StatelessWidget {
  const QLCheckbox._({
    required this.onChanged,
    required this.state,
    this.labelText,
    this.helperText,
    this.errorMessage,
    this.prefixIcon,
    this.controlAffinity,
    super.key,
  });

  factory QLCheckbox.standard({
    required void Function(QLCheckboxState)? onChanged,
    Key? key,
    String? labelText,
    String? helperText,
    String? errorMessage,
    Widget? prefixIcon,
    ListTileControlAffinity? controlAffinity,
    QLCheckboxState state = QLCheckboxState.unchecked,
  }) =>
      QLCheckbox._(
        key: key,
        onChanged: onChanged,
        labelText: labelText,
        helperText: helperText,
        errorMessage: errorMessage,
        prefixIcon: prefixIcon,
        controlAffinity: controlAffinity,
        state: state,
      );

  final String? labelText;
  final String? helperText;
  final String? errorMessage;
  final Widget? prefixIcon;
  final ListTileControlAffinity? controlAffinity;
  final QLCheckboxState state;
  final void Function(QLCheckboxState)? onChanged;

  @override
  Widget build(BuildContext context) {
    final subtitle = errorMessage ?? helperText;
    final value = state.toValue();

    return CheckboxListTile(
      onChanged: (value) => onChanged?.call(QLCheckboxState.fromValue(value: value)),
      tristate: true,
      dense: true,
      checkboxShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3),
      ),
      controlAffinity: controlAffinity ?? ListTileControlAffinity.leading,
      secondary: prefixIcon,
      enabled: onChanged != null,
      isError: errorMessage != null,
      selected: value ?? false,
      title: labelText != null ? Text(labelText!) : null,
      contentPadding: EdgeInsets.zero,
      checkColor: Theme.of(context).themeColors.textColors.contrast,
      activeColor: Theme.of(context).themeColors.mainColors.primary,
      side: BorderSide(
        color: Theme.of(context).themeColors.mainColors.subtle,
        width: 2,
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                color: errorMessage != null ? Theme.of(context).themeColors.mainColors.error : null,
              ),
            )
          : null,
      value: value,
    );
  }
}

enum QLCheckboxState {
  checked,
  unchecked,
  indeterminate;

  static QLCheckboxState fromValue({bool? value}) {
    if (value == null) {
      return QLCheckboxState.indeterminate;
    }

    return value ? QLCheckboxState.checked : QLCheckboxState.unchecked;
  }

  bool? toValue() {
    if (this == QLCheckboxState.indeterminate) {
      return null;
    }

    return this == QLCheckboxState.checked;
  }

  bool get isIndeterminate => this == QLCheckboxState.indeterminate;

  bool get isChecked => this == QLCheckboxState.checked;

  bool get isUnchecked => this == QLCheckboxState.unchecked;
}
