import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/domain/repository/auth_repository.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/auth/domain/use_cases/login_anonymously_use_case.dart';

void main() {
  late QuizLabLogger loggerMock;
  late AuthRepository authRepositoryMock;

  late LoginAnonymouslyUseCase useCase;

  setUp(() {
    loggerMock = _MockQuizLabLogger();
    authRepositoryMock = _MockAuthRepository();

    useCase = LoginAnonymouslyUseCaseImpl(
      logger: loggerMock,
      authRepository: authRepositoryMock,
    );
  });

  tearDown(resetMocktailState);

  test('should log initial message', () {
    when(() => authRepositoryMock.loginAnonymously())
        .thenAnswer((_) async => const Err('!meldT'));

    useCase();

    verify(() => loggerMock.debug('Executing...')).called(1);
  });

  group('should use auth repository', () {
    test('should call login anonymously', () async {
      when(() => authRepositoryMock.loginAnonymously())
          .thenAnswer((_) async => const Err('90c5uwE'));

      await useCase();

      verify(() => authRepositoryMock.loginAnonymously()).called(1);
    });

    group('should handle error response', () {
      for (final error in ['WCIoS', 'p8gA*sxu']) {
        test(error, () async {
          when(() => authRepositoryMock.loginAnonymously())
              .thenAnswer((_) async => Err(error));

          final result = await useCase();

          verify(() => loggerMock.error(error)).called(1);
          expect(result.containsErr('Unable to login anonymously'), true);
        });
      }
    });

    test('should return Unit if auth repository succeeds', () async {
      when(() => authRepositoryMock.loginAnonymously())
          .thenAnswer((_) async => const Ok(unit));

      final result = await useCase();

      expect(result.contains(unit), true);
    });
  });
}

class _MockQuizLabLogger extends Mock implements QuizLabLogger {}

class _MockAuthRepository extends Mock implements AuthRepository {}
