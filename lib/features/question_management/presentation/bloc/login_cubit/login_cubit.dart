import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/login_anonymously_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/login_with_credentials_use_case.dart';
import 'package:rust_core/result.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required QuizLabLogger logger,
    required LoginWithCredentialsUseCase loginWithCredentialsUseCase,
    required LoginAnonymouslyUseCase loginAnonymouslyUseCase,
  })  : _logger = logger,
        _loginWithCredentialsUseCase = loginWithCredentialsUseCase,
        _loginAnonymouslyUseCase = loginAnonymouslyUseCase,
        super(const LoginState());

  final QuizLabLogger _logger;
  final LoginWithCredentialsUseCase _loginWithCredentialsUseCase;
  final LoginAnonymouslyUseCase _loginAnonymouslyUseCase;

  void updateEmail(String email) {
    _logger.debug('Received email input');

    _emitNewEmailValue(email);
    _validateEmail(email);
  }

  void updatePassword(String password) {
    _logger.debug('Received password input');

    _emitNewPasswordValue(password);
    _validatePassword(password);
  }

  Future<void> login() async {
    _logger.debug('Received login request');

    _emitLoading();

    if (!_validateEmail(state.email) || !_validatePassword(state.password)) {
      return emit(state.copyWith(loading: false));
    }

    (await _loginWithCredentials())
        .inspect(
          (value) => emit(
            state.copyWith(
              success: true,
              loading: false,
            ),
          ),
        )
        .inspectErr((errorCode) => emit(state.copyWith(generalErrorCode: errorCode, loading: false)));
  }

  Future<void> enterAnonymously() async {
    _logger.info('Logging in anonymously...');

    _emitLoading();

    (await _loginAnonymously())
        .inspect((_) => emit(state.copyWith(success: true, loading: false)))
        .inspectErr((error) => emit(state.copyWith(generalErrorCode: error, loading: false)));
  }

  void signUp() => emit(state.copyWith(generalMessageCode: _LoginCubitGeneralMessageCode.notImplemented.name));

  void _emitNewEmailValue(String email) => emit(state.copyWith(email: email));

  bool _validateEmail(String email) {
    _logger.debug('Validating email...');

    if (email.isEmpty) {
      _logger.warn('Email must be set');

      emit(
        state.copyWith(
          emailErrorCode: _LoginCubitErrorCode.emptyValue.name,
          showEmailError: true,
        ),
      );

      return false;
    }

    return true;
  }

  void _emitNewPasswordValue(String password) => emit(state.copyWith(password: password));

  bool _validatePassword(String password) {
    _logger.debug('Validating password...');

    if (password.isEmpty) {
      _logger.warn('Password must be set');

      emit(
        state.copyWith(
          passwordErrorCode: _LoginCubitErrorCode.emptyValue.name,
          showPasswordError: true,
        ),
      );

      return false;
    }

    return true;
  }

  void _emitLoading() => emit(state.copyWith(loading: true));

  Future<Result<Unit, String>> _loginWithCredentials() async => (await _loginWithCredentialsUseCase(
        LoginWithCredentialsUseCaseInput(
          email: state.email,
          password: state.password,
        ),
      ))
          .inspectErr(_logger.error)
          .mapErr((_) => _LoginCubitErrorCode.unableToLogin.name);

  Future<Result<Unit, String>> _loginAnonymously() async => (await _loginAnonymouslyUseCase.call())
      .inspectErr(_logger.error)
      .mapErr((_) => _LoginCubitErrorCode.unableToLogin.name);
}

enum _LoginCubitErrorCode {
  emptyValue,
  unableToLogin,
}

enum _LoginCubitGeneralMessageCode {
  notImplemented,
}
