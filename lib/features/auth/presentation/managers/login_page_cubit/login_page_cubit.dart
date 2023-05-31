import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_lab/core/domain/use_cases/fetch_application_version_use_case.dart';
import 'package:quiz_lab/core/utils/logger/impl/quiz_lab_logger_factory.dart';
import 'package:quiz_lab/core/utils/routes.dart';
import 'package:quiz_lab/features/auth/domain/use_cases/login_with_credentials_use_case.dart';
import 'package:quiz_lab/features/auth/presentation/managers/login_page_cubit/view_models/login_page_view_model.dart';

part 'login_page_state.dart';

class LoginPageCubit extends Cubit<LoginPageState> {
  LoginPageCubit({
    required LoginWithCredentialsUseCase loginWithCredentionsUseCase,
    required FetchApplicationVersionUseCase fetchApplicationVersionUseCase,
  })  : _loginWithCredentionsUseCase = loginWithCredentionsUseCase,
        _fetchApplicationVersionUseCase = fetchApplicationVersionUseCase,
        super(const LoginPageInitial());

  final _logger = QuizLabLoggerFactory.createLogger<LoginPageCubit>();
  final LoginWithCredentialsUseCase _loginWithCredentionsUseCase;
  final FetchApplicationVersionUseCase _fetchApplicationVersionUseCase;

  late LoginPageViewModel _viewModel;

  final LoginPageViewModel _defaultViewModel = const LoginPageViewModel(
    email: EmailViewModel(
      value: '',
    ),
    password: PasswordViewModel(
      value: '',
    ),
    applicationVersion: '',
  );

  void hydrate() {
    _logger.debug('Hydrating...');

    final rawVersion = _fetchApplicationVersionUseCase.execute();
    final applicationVersion = 'v${rawVersion}';

    _logger.debug('Fetched application version: $applicationVersion');
    final defaultViewModelUpdatedWithApplicationVersion = _defaultViewModel.copyWith(
      applicationVersion: applicationVersion,
    );

    _viewModel = defaultViewModelUpdatedWithApplicationVersion;

    emit(
      LoginPageState.viewModelUpdated(_viewModel),
    );
  }

  void onEmailChange(String email) {
    _logger.debug('Received email input');

    _viewModel = _viewModel.copyWith(
      email: _viewModel.email.copyWith(
        value: email,
        showError: true,
      ),
    );

    emit(
      LoginPageState.viewModelUpdated(_viewModel),
    );
  }

  void onPasswordChange(String password) {
    _logger.debug('Received password input');

    _viewModel = _viewModel.copyWith(
      password: _viewModel.password.copyWith(
        value: password,
        showError: true,
      ),
    );

    emit(
      LoginPageState.viewModelUpdated(_viewModel),
    );
  }

  Future<void> onLogin() async {
    _logger.debug('Received login request');
    emit(LoginPageState.loading());

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
      emit(
        LoginPageState.viewModelUpdated(_viewModel),
      );
      return;
    }

    final logInResult = await _loginWithCredentionsUseCase(
      LoginWithCredentialsUseCaseInput(
        email: _viewModel.email.value,
        password: _viewModel.password.value,
      ),
    );

    if (logInResult.isErr) {
      emit(LoginPageState.viewModelUpdated(_defaultViewModel));

      emit(
        LoginPageState.displayErrorMessage(
          LoginPageErrorTypeViewModel.unableToLogin,
        ),
      );

      return;
    }

    emit(LoginPageState.displayLoggedInMessage());

    emit(LoginPageState.pushRouteReplacing(Routes.questionsOverview));
  }

  void onEnterAnonymously() => throw UnimplementedError();

  void onSignUp() {
    emit(LoginPageState.displayNotYetImplementedMessage());
  }
}
