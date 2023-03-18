import 'package:flutter/foundation.dart';

@immutable
class LoginPageViewModel {
  const LoginPageViewModel({
    required this.email,
    required this.password,
  });

  final EmailViewModel email;
  final PasswordViewModel password;

  LoginPageViewModel copyWith({
    EmailViewModel? email,
    PasswordViewModel? password,
  }) {
    return LoginPageViewModel(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
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

  EmailViewModel copyWith({
    String? value,
    bool? showError,
  }) {
    return EmailViewModel(
      value: value ?? this.value,
      showError: showError ?? this.showError,
    );
  }
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

  PasswordViewModel copyWith({
    String? value,
    bool? showError,
  }) {
    return PasswordViewModel(
      value: value ?? this.value,
      showError: showError ?? this.showError,
    );
  }
}

enum LoginPageErrorTypeViewModel {
  unableToLogin,
  generic,
}
