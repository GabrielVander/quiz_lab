part of 'login_page_cubit.dart';

@immutable
abstract class LoginPageState extends Equatable {
  const LoginPageState._();

  factory LoginPageState.initial() => const LoginPageInitial();

  factory LoginPageState.viewModelUpdated(LoginPageViewModel viewModel) =>
      LoginPageViewModelUpdated(viewModel: viewModel);

  factory LoginPageState.pushRouteReplacing(Routes route) =>
      LoginPagePushRouteReplacing(route: route);

  factory LoginPageState.displayErrorMessage(
    LoginPageErrorTypeViewModel type,
  ) =>
      LoginPageDisplayErrorMessage(type);

  factory LoginPageState.displayLoggedInMessage() =>
      const LoginPageDisplayLoggedInMessage._();

  factory LoginPageState.displayNotYetImplementedMessage() =>
      const LoginPageDisplayNotYetImplementedMessage._();

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

class LoginPageDisplayErrorMessage extends LoginPageState {
  const LoginPageDisplayErrorMessage(this.type) : super._();

  final LoginPageErrorTypeViewModel type;

  @override
  List<Object> get props => [type];
}

class LoginPageDisplayLoggedInMessage extends LoginPageState {
  const LoginPageDisplayLoggedInMessage._() : super._();

  @override
  List<Object> get props => [];
}

class LoginPageDisplayNotYetImplementedMessage extends LoginPageState {
  const LoginPageDisplayNotYetImplementedMessage._() : super._();

  @override
  List<Object> get props => [];
}

class LoginPageLoading extends LoginPageState {
  const LoginPageLoading._() : super._();

  @override
  List<Object> get props => [];
}
