part of 'login_cubit.dart';

@immutable
sealed class LoginState extends Equatable {
  const LoginState();
}

class LoginPageInitial extends LoginState {
  const LoginPageInitial();

  @override
  List<Object> get props => [];
}

class LoginPageViewModelUpdated extends LoginState {
  const LoginPageViewModelUpdated({required this.viewModel});

  final LoginViewModel viewModel;

  @override
  List<Object> get props => [viewModel];
}

class LoginPagePushRouteReplacing extends LoginState {
  const LoginPagePushRouteReplacing({required this.route});

  final Routes route;

  @override
  List<Object> get props => [route];
}

class LoginPageError extends LoginState {
  const LoginPageError();

  @override
  List<Object> get props => [];
}

class LoginPageUnableToLogin extends LoginState {
  const LoginPageUnableToLogin();

  @override
  List<Object> get props => [];
}

class LoginPageLoggedInSuccessfully extends LoginState {
  const LoginPageLoggedInSuccessfully();

  @override
  List<Object> get props => [];
}

class LoginPageNotYetImplemented extends LoginState {
  const LoginPageNotYetImplemented();

  @override
  List<Object> get props => [];
}

class LoginPageLoading extends LoginState {
  const LoginPageLoading();

  @override
  List<Object> get props => [];
}
