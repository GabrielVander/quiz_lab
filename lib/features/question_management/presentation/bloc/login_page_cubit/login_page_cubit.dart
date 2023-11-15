import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/routes.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/login_anonymously_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/login_with_credentials_use_case.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/login_page_cubit/view_models/login_page_view_model.dart';

part 'login_page_state.dart';

class LoginPageCubit extends Cubit<LoginPageState> {
  LoginPageCubit({
    required this.logger,
    required this.loginWithCredentialsUseCase,
    required this.loginAnonymouslyUseCase,
  }) : super(const LoginPageInitial());

  final QuizLabLogger logger;
  final LoginWithCredentialsUseCase loginWithCredentialsUseCase;
  final LoginAnonymouslyUseCase loginAnonymouslyUseCase;

  late LoginPageViewModel _viewModel;

  final LoginPageViewModel _defaultViewModel = const LoginPageViewModel(
    email: EmailViewModel(
      value: '',
    ),
    password: PasswordViewModel(
      value: '',
    ),
  );

  void hydrate() {
    logger.debug('Hydrating...');
    _viewModel = _defaultViewModel;

    emit(LoginPageViewModelUpdated(viewModel: _viewModel));
  }

  void updateEmail(String email) {
    logger.debug('Received email input');

    _viewModel = _viewModel.copyWith(
      email: _viewModel.email.copyWith(
        value: email,
        showError: true,
      ),
    );

    emit(
      LoginPageViewModelUpdated(viewModel: _viewModel),
    );
  }

  void updatePassword(String password) {
    logger.debug('Received password input');

    _viewModel = _viewModel.copyWith(
      password: _viewModel.password.copyWith(
        value: password,
        showError: true,
      ),
    );

    emit(
      LoginPageViewModelUpdated(viewModel: _viewModel),
    );
  }

  Future<void> login() async {
    logger.debug('Received login request');
    emit(const LoginPageLoading());

    final isEmailEmpty = _viewModel.email.value.isEmpty;
    final isPasswordEmpty = _viewModel.password.value.isEmpty;

    if (isEmailEmpty) {
      _viewModel = _viewModel.copyWith(
        email: _viewModel.email.copyWith(
          showError: true,
        ),
      );
    }

    if (isPasswordEmpty) {
      _viewModel = _viewModel.copyWith(
        password: _viewModel.password.copyWith(
          showError: true,
        ),
      );
    }

    if (isEmailEmpty || isPasswordEmpty) {
      emit(LoginPageViewModelUpdated(viewModel: _viewModel));
      return;
    }

    final logInResult = await loginWithCredentialsUseCase(
      LoginWithCredentialsUseCaseInput(
        email: _viewModel.email.value,
        password: _viewModel.password.value,
      ),
    );

    if (logInResult.isErr) {
      emit(const LoginPageUnableToLogin());
      emit(LoginPageViewModelUpdated(viewModel: _defaultViewModel));

      return;
    }

    emit(const LoginPageLoggedInSuccessfully());
    emit(const LoginPagePushRouteReplacing(route: Routes.questionsOverview));
  }

  Future<void> enterAnonymously() async {
    emit(const LoginPageLoading());

    final result = await loginAnonymouslyUseCase();

    result.inspectErr(_onLoginFailed).inspect(_onLoginSucceeded);
  }

  void signUp() => emit(const LoginPageNotYetImplemented());

  void _onLoginFailed(String error) {
    logger.error(error);

    emit(const LoginPageUnableToLogin());
    emit(const LoginPageInitial());
  }

  void _onLoginSucceeded(_) {
    logger.info('Logged in successfully. Redirecting...');

    emit(const LoginPageLoggedInSuccessfully());
    emit(const LoginPagePushRouteReplacing(route: Routes.questionsOverview));
  }
}
