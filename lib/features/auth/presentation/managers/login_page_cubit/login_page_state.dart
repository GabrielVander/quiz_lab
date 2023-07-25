part of 'login_page_cubit.dart';

@immutable
sealed class LoginPageState extends Equatable {
  const LoginPageState._();

  factory LoginPageState.initial() => const LoginPageInitial();

  factory LoginPageState.viewModelUpdated(LoginPageViewModel viewModel) =>
      LoginPageViewModelUpdated(viewModel: viewModel);

  factory LoginPageState.pushRouteReplacing(Routes route) =>
      LoginPagePushRouteReplacing(route: route);

  factory LoginPageState.displayErrorMessage(
    LoginPageErrorTypeViewModel type,
  ) =>
      LoginPageError(type);

  factory LoginPageState.displayLoggedInMessage() => const LoginPageDisplayLoggedInMessage._();

  factory LoginPageState.displayNotYetImplementedMessage() => const LoginPageNotYetImplemented._();

  factory LoginPageState.loading() => const LoginPageLoading._();
}

class LoginPageInitial extends LoginPageState {
  const LoginPageInitial() : super._();

  @override
  List<Object> get props => [];
}

class LoginPageViewModelUpdated extends LoginPageState {
  const LoginPageViewModelUpdated({required this.viewModel}) : super._();

  final LoginPageViewModel viewModel;

  @override
  List<Object> get props => [viewModel];
}

class LoginPagePushRouteReplacing extends LoginPageState {
  const LoginPagePushRouteReplacing({required this.route}) : super._();

  final Routes route;

  @override
  List<Object> get props => [route];
}

class LoginPageError extends LoginPageState {
  const LoginPageError(this.type) : super._();

  final LoginPageErrorTypeViewModel type;

  @override
  List<Object> get props => [type];
}

class LoginPageDisplayLoggedInMessage extends LoginPageState {
  const LoginPageDisplayLoggedInMessage._() : super._();

  @override
  List<Object> get props => [];
}

class LoginPageNotYetImplemented extends LoginPageState {
  const LoginPageNotYetImplemented._() : super._();

  @override
  List<Object> get props => [];
}

class LoginPageLoading extends LoginPageState {
  const LoginPageLoading._() : super._();

  @override
  List<Object> get props => [];
}
