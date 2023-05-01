import 'package:equatable/equatable.dart';
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
class EmailViewModel extends Equatable {
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

  @override
  List<Object> get props => [value, showError];
}

@immutable
class PasswordViewModel extends Equatable {
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

  @override
  List<Object> get props => [value, showError];
}

enum LoginPageErrorTypeViewModel {
  unableToLogin,
  generic,
}
