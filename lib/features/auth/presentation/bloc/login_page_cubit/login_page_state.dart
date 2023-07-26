part of 'login_page_cubit.dart';

@immutable
sealed class LoginPageState extends Equatable {
  const LoginPageState();
}

class LoginPageInitial extends LoginPageState {
  const LoginPageInitial();

  @override
  List<Object> get props => [];
}

class LoginPageViewModelUpdated extends LoginPageState {
  const LoginPageViewModelUpdated({required this.viewModel});

  final LoginPageViewModel viewModel;

  @override
  List<Object> get props => [viewModel];
}

class LoginPagePushRouteReplacing extends LoginPageState {
  const LoginPagePushRouteReplacing({required this.route});

  final Routes route;

  @override
  List<Object> get props => [route];
}

class LoginPageError extends LoginPageState {
  const LoginPageError(this.type);

  final LoginPageErrorTypeViewModel type;

  @override
  List<Object> get props => [type];
}

class LoginPageLoggedInSuccessfully extends LoginPageState {
  const LoginPageLoggedInSuccessfully();

  @override
  List<Object> get props => [];
}

class LoginPageNotYetImplemented extends LoginPageState {
  const LoginPageNotYetImplemented();

  @override
  List<Object> get props => [];
}

class LoginPageLoading extends LoginPageState {
  const LoginPageLoading();

  @override
  List<Object> get props => [];
}
