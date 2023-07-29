import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/features/auth/domain/repository/auth_repository.dart';
import 'package:quiz_lab/features/auth/domain/use_cases/check_if_user_is_logged_in_use_case.dart';

void main() {
  late QuizLabLogger loggerMock;
  late AuthRepository authRepository;

  late CheckIfUserIsLoggedInUseCase useCase;

  setUp(() {
    loggerMock = _MockQuizLabLogger();
    authRepository = _MockAuthRepository();

    useCase = CheckIfUserIsLoggedInUseCaseImpl(
      logger: loggerMock,
      authRepository: authRepository,
    );
  });

  tearDown(resetMocktailState);

  test('should log initial message', () {
    when(() => authRepository.isLoggedIn())
        .thenAnswer((_) async => const Err('a23'));

    useCase();

    verify(() => loggerMock.debug('Executing...')).called(1);
  });

  group('should fail if auth repository fails', () {
    for (final error in ['pdP', '3cN4ANF']) {
      test(error, () async {
        when(() => authRepository.isLoggedIn())
            .thenAnswer((_) async => Err(error));

        final result = await useCase();

        verify(() => loggerMock.error(error)).called(1);
        expect(
          result,
          const Err<bool, String>('Unable to check if user is logged in'),
        );
      });
    }
  });

  group('should return expected result if auth repository succeeds', () {
    for (final isLoggedIn in [true, false]) {
      test(isLoggedIn.toString(), () async {
        when(() => authRepository.isLoggedIn())
            .thenAnswer((_) async => Ok(isLoggedIn));

        final result = await useCase();

        verifyNever(() => loggerMock.error(any()));
        expect(result, Ok<bool, String>(isLoggedIn));
      });
    }
  });
}

class _MockQuizLabLogger extends Mock implements QuizLabLogger {}

class _MockAuthRepository extends Mock implements AuthRepository {}
