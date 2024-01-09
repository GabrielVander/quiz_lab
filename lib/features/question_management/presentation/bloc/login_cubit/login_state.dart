part of 'login_cubit.dart';

class LoginState extends Equatable {
  const LoginState({
    this.email = '',
    this.password = '',
    this.loading = false,
    this.success = false,
    this.emailErrorCode,
    this.showEmailError = false,
    this.passwordErrorCode,
    this.showPasswordError = false,
    this.generalErrorCode,
    this.generalMessageCode,
  });

  final String email;
  final String? emailErrorCode;
  final bool showEmailError;
  final String password;
  final String? passwordErrorCode;
  final bool showPasswordError;
  final bool loading;
  final String? generalErrorCode;
  final String? generalMessageCode;
  final bool success;

  LoginState copyWith({
    String? email,
    String? emailErrorCode,
    bool? showEmailError,
    String? password,
    String? passwordErrorCode,
    bool? showPasswordError,
    bool? loading,
    String? generalErrorCode,
    String? generalMessageCode,
    bool? success,
  }) =>
      LoginState(
        email: email ?? this.email,
        emailErrorCode: emailErrorCode ?? this.emailErrorCode,
        showEmailError: showEmailError ?? this.showEmailError,
        password: password ?? this.password,
        passwordErrorCode: passwordErrorCode ?? this.passwordErrorCode,
        showPasswordError: showPasswordError ?? this.showPasswordError,
        loading: loading ?? this.loading,
        generalErrorCode: generalErrorCode ?? this.generalErrorCode,
        generalMessageCode: generalMessageCode ?? this.generalMessageCode,
        success: success ?? this.success,
      );

  @override
  String toString() => 'LoginState{'
      'email: $email, '
      'emailErrorCode: $emailErrorCode, '
      'showEmailError: $showEmailError, '
      'password: $password, '
      'passwordErrorCode: $passwordErrorCode, '
      'showPasswordError: $showPasswordError, '
      'loading: $loading, '
      'generalErrorCode: $generalErrorCode, '
      'generalMessageCode: $generalMessageCode, '
      'success: $success'
      '}';

  @override
  List<Object?> get props => [
        email,
        emailErrorCode,
        showEmailError,
        password,
        passwordErrorCode,
        showPasswordError,
        loading,
        success,
        generalErrorCode,
        generalMessageCode,
      ];
}
