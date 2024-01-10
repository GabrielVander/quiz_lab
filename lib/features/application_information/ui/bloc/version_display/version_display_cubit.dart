import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/features/application_information/domain/usecases/retrieve_application_version.dart';
import 'package:rust_core/result.dart';

part 'version_display_state.dart';

class VersionDisplayCubit extends Cubit<VersionDisplayState> {
  VersionDisplayCubit(this._logger, this._retrieveApplicationVersionUseCase) : super(_initialState);

  static const _initialState = VersionDisplayState(version: '-', isLoading: true);
  VersionDisplayState _currentState = _initialState;

  final QuizLabLogger _logger;
  final RetrieveApplicationVersion _retrieveApplicationVersionUseCase;

  Future<void> displayApplicationVersion() async {
    _logger.info('Retrieving application version to be displayed...');

    emit(_currentState);

    (await _retrieveApplicationVersion())
        .inspect(_emitNewVersion)
        .mapErr((_) => VersionDisplayCubitErrorCodes.unableToRetrieveApplicationVersion.name)
        .inspectErr(_emitErrorMessage);
  }

  void _emitNewVersion(String version) {
    _currentState = _currentState.copyWith(version: version, isLoading: false);

    emit(_currentState);
  }

  void _emitErrorMessage(String e) {
    _currentState = _currentState.copyWith(isLoading: false, errorCode: e);
    emit(_currentState);
  }

  Future<Result<String, String>> _retrieveApplicationVersion() async =>
      (await _retrieveApplicationVersionUseCase.call()).map((version) => 'v$version').inspectErr(_logger.error);
}

enum VersionDisplayCubitErrorCodes {
  unableToRetrieveApplicationVersion,
}
