import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/features/question_management/domain/entities/current_user_session.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/auth_repository.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/check_if_user_can_create_public_questions_use_case.dart';

void main() {
  late QuizLabLogger logger;
  late AuthRepository authRepository;

  late CheckIfUserCanCreatePublicQuestionsUseCase useCase;

  setUp(() {
    logger = _MockQuizLabLogger();
    authRepository = _MockAuthRepository();

    useCase = CheckIfUserCanCreatePublicQuestionsUseCaseImpl(
      logger: logger,
      authRepository: authRepository,
    );
  });

  test('should log initial message', () async {
    when(() => authRepository.getCurrentSession()).thenAnswer((_) async => const Err('UYE8SH'));

    await useCase();

    verify(() => logger.info('Executing...')).called(1);
  });

  group('should log and fail when auth repository fails', () {
    for (final error in ['4Sx', 'ILi']) {
      test('with error: $error', () async {
        when(() => authRepository.getCurrentSession()).thenAnswer(
          (_) async => Err(error),
        );

        final result = await useCase();

        verify(() => logger.error(error)).called(1);
        expect(
          result,
          const Err<bool, String>(
            'Unable to check if user can create public questions',
          ),
        );
      });
    }
  });

  group('should return expected based on auth repository result', () {
    for (final testCase in [
      (_FakeCurrentEmailSession(), true),
      (_FakeCurrentUnknownSession(), false),
      (_FakeCurrentAnonymousSession(), false),
      (null, false),
    ]) {
      test('when receiving session: ${testCase.$1} should return ${testCase.$2}', () async {
        when(() => authRepository.getCurrentSession()).thenAnswer((_) async => Ok(testCase.$1));

        final result = await useCase();

        verifyNever(() => logger.error(any()));
        expect(result, Ok<bool, String>(testCase.$2));
      });
    }
  });
}

class _MockQuizLabLogger extends Mock implements QuizLabLogger {}

class _MockAuthRepository extends Mock implements AuthRepository {}

class _FakeCurrentEmailSession extends Fake implements CurrentUserSession {
  @override
  final SessionProvider provider = SessionProvider.email;
}

class _FakeCurrentUnknownSession extends Fake implements CurrentUserSession {
  @override
  final SessionProvider provider = SessionProvider.unknown;
}

class _FakeCurrentAnonymousSession extends Fake implements CurrentUserSession {
  @override
  final SessionProvider provider = SessionProvider.anonymous;
}
