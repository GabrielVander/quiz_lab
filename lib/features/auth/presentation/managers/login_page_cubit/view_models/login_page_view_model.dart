import 'package:flutter/foundation.dart';

@immutable
class LoginPageViewModel {
  const LoginPageViewModel({
    required this.email,
    required this.password,
  });

  bool get emailHasError => email.isEmpty;

  final EmailViewModel email;
  final PasswordViewModel password;
}

@immutable
class EmailViewModel {
  const EmailViewModel({
    required this.value,
    this.showError = false,
  });

  final String value;
  final bool showError;

  bool get isEmpty => value.isEmpty;
}

@immutable
class PasswordViewModel {
  const PasswordViewModel({
    required this.value,
    this.showError = false,
  });

  final String value;
  final bool showError;

  bool get isEmpty => value.isEmpty;
}
