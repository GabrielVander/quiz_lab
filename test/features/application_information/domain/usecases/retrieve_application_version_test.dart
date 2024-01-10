import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/features/application_information/domain/repositories/application_version_repository.dart';
import 'package:quiz_lab/features/application_information/domain/usecases/retrieve_application_version.dart';
import 'package:rust_core/result.dart';

void main() {
  late QuizLabLogger logger;
  late ApplicationVersionRepository applicationVersionRepository;

  late RetrieveApplicationVersion useCase;

  setUp(() {
    logger = _MockQuizLabLogger();
    applicationVersionRepository = _MockApplicationVersionRepository();

    useCase = RetrieveApplicationVersionImpl(
      logger: logger,
      applicationVersionRepository: applicationVersionRepository,
    );
  });

  test('should log initial message', () async {
    when(() => applicationVersionRepository.fetchVersionName()).thenAnswer((_) async => const Err('^H1#S'));

    await useCase();

    verify(() => logger.debug('Executing...')).called(1);
  });

  group('should return Err when repository fails', () {
    for (final message in ['WtZ6^', '!ffh41KP']) {
      test('with $message as message', () async {
        when(() => applicationVersionRepository.fetchVersionName()).thenAnswer((_) async => Err(message));

        final result = await useCase();

        verify(() => applicationVersionRepository.fetchVersionName()).called(1);
        verify(() => logger.error(message)).called(1);
        expect(result, const Err<String, String>('Unable to retrieve application version'));
      });
    }
  });

  group('should return Ok', () {
    for (final version in ['6w3O', r'kD7!0$']) {
      test('with $version as version', () async {
        when(() => applicationVersionRepository.fetchVersionName()).thenAnswer((_) async => Ok(version));

        final result = await useCase();

        verify(() => applicationVersionRepository.fetchVersionName()).called(1);
        expect(result, Ok<String, String>(version));
      });
    }
  });
}

class _MockQuizLabLogger extends Mock implements QuizLabLogger {}

class _MockApplicationVersionRepository extends Mock implements ApplicationVersionRepository {}
