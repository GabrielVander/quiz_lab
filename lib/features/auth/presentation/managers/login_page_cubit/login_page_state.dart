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

  factory LoginPageState.displayLoggedInMessage() =>
      const LoginPageDisplayLoggedInMessage._();

  factory LoginPageState.displayNotYetImplementedMessage() =>
      const LoginPageDisplayNotYetImplementedMessage._();

  factory LoginPageState.loading() => const LoginPageLoading._();
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
  const LoginPageDisplayLoggedInMessage._() : super._();
}

class LoginPageDisplayNotYetImplementedMessage extends LoginPageState {
  const LoginPageDisplayNotYetImplementedMessage._() : super._();
}

class LoginPageLoading extends LoginPageState {
  const LoginPageLoading._() : super._();
}