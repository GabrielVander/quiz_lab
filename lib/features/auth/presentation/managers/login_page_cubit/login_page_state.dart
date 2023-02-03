part of 'login_page_cubit.dart';

@immutable
abstract class LoginPageState {
  const LoginPageState._();

  factory LoginPageState.initial() => const LoginPageInitial._();

  factory LoginPageState.viewModelUpdated(LoginPageViewModel viewModel) =>
      LoginPageViewModelUpdated._(viewModel: viewModel);

  factory LoginPageState.pushRouteReplacing(Routes route) =>
      LoginPagePushRouteReplacing._(route: route);

  factory LoginPageState.displayErrorMessage(
    LoginPageErrorTypeViewModel type,
  ) =>
      LoginPageDisplayErrorMessage._(type);

  factory LoginPageState.displayLoggedInMessage(String username) =>
      LoginPageDisplayLoggedInMessage._(username);
}

class LoginPageInitial extends LoginPageState {
  const LoginPageInitial._() : super._();
}

class LoginPageViewModelUpdated extends LoginPageState {
  const LoginPageViewModelUpdated._({required this.viewModel}) : super._();

  final LoginPageViewModel viewModel;
}

class LoginPagePushRouteReplacing extends LoginPageState {
  const LoginPagePushRouteReplacing._({required this.route}) : super._();

  final Routes route;
}

class LoginPageDisplayErrorMessage extends LoginPageState {
  const LoginPageDisplayErrorMessage._(this.type) : super._();

  final LoginPageErrorTypeViewModel type;
}

class LoginPageDisplayLoggedInMessage extends LoginPageState {
  const LoginPageDisplayLoggedInMessage._(this.username) : super._();

  final String username;
}
