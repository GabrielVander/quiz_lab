import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/data/data_sources/auth_appwrite_data_source.dart';
import 'package:quiz_lab/core/data/models/appwrite_error_model.dart';
import 'package:quiz_lab/core/data/models/email_session_credentials_model.dart';
import 'package:quiz_lab/core/data/models/session_model.dart';
import 'package:quiz_lab/core/data/models/user_model.dart';
import 'package:quiz_lab/core/data/repositories/auth_repository_impl.dart';
import 'package:quiz_lab/core/domain/entities/current_user_session.dart';
import 'package:quiz_lab/core/domain/repository/auth_repository.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/unit.dart';

void main() {
  late AuthAppwriteDataSource authDataSource;
  late QuizLabLogger logger;

  late AuthRepositoryImpl repository;

  setUp(() {
    logger = _MockQuizLabLogger();
    authDataSource = _AuthAppwriteDataSourceMock();

    repository = AuthRepositoryImpl(
      logger: logger,
      authDataSource: authDataSource,
    );

    registerFallbackValue(_MockEmailSessionCredentialsModel());
  });

  group('loginWithEmailCredentials', () {
    group(
      'should return unexpected error',
      () {
        for (final errorMessage in ['', 'R02!OA']) {
          test(errorMessage, () async {
            when(() => authDataSource.createEmailSession(any())).thenAnswer((_) async => Err(errorMessage));

            final result = await repository.loginWithEmailCredentials(_MockEmailCredentials());

            expect(result.isErr, true);

            final expected = AuthRepositoryError.unexpected(message: errorMessage);
            expect(result.unwrapErr(), expected);
            expect(result.unwrapErr().hashCode, expected.hashCode);
          });
        }
      },
    );

    group(
      'should call appwrite data source with given credentials and return ok if'
      ' data source returns ok',
      () {
        for (final values in [
          ['', ''],
          ['Vhn', 'u4N6'],
        ]) {
          test(values.toString(), () async {
            final email = values[0];
            final password = values[1];

            when(
              () => authDataSource.createEmailSession(
                EmailSessionCredentialsModel(
                  email: email,
                  password: password,
                ),
              ),
            ).thenAnswer((_) async => Ok(_MockSessionModel()));

            final result = await repository.loginWithEmailCredentials(
              EmailCredentials(email: email, password: password),
            );

            expect(result.isOk, true);
            expect(result.unwrap(), unit);
          });
        }
      },
    );
  });

  group('loginAnonymously()', () {
    test('should log initial message', () async {
      when(() => authDataSource.createAnonymousSession()).thenAnswer((_) async => const Err('UPjDe'));

      await repository.loginAnonymously();

      verify(() => logger.debug('Logging in anonymously...')).called(1);
    });

    group('should fail if auth data source fails', () {
      for (final errorMessage in ['73sOg87', '3Eq7Yt']) {
        test(errorMessage, () async {
          when(() => authDataSource.createAnonymousSession()).thenAnswer((_) async => Err(errorMessage));

          final result = await repository.loginAnonymously();

          verify(() => logger.error(errorMessage)).called(1);
          expect(
            result,
            const Err<Unit, String>('Unable to login anonymously'),
          );
        });
      }
    });

    test('should return ok if auth data source returns ok', () async {
      when(() => authDataSource.createAnonymousSession()).thenAnswer((_) async => const Ok(unit));

      final result = await repository.loginAnonymously();

      expect(result, const Ok<Unit, String>(unit));
    });
  });

  group('isLoggedIn', () {
    test('should log initial message', () async {
      when(() => authDataSource.getCurrentUser()).thenAnswer((_) async => const Err('35W5a41'));

      await repository.isLoggedIn();

      verify(() => logger.debug('Checking if user is logged in...')).called(1);
    });

    group('should return false if auth data source fails', () {
      for (final errorMessage in ['I3vI1Q5s', 'EtiUuAzt']) {
        test(errorMessage, () async {
          when(() => authDataSource.getCurrentUser()).thenAnswer((_) async => Err(errorMessage));

          final result = await repository.isLoggedIn();

          verify(() => logger.error(errorMessage)).called(1);
          expect(result, const Ok<bool, String>(false));
        });
      }
    });

    test('should return true if auth data source returns ok', () async {
      when(() => authDataSource.getCurrentUser()).thenAnswer((_) async => Ok(_MockUserModel()));

      final result = await repository.isLoggedIn();

      verifyNever(() => logger.error(any()));
      verify(() => logger.debug('User is logged in')).called(1);
      expect(result, const Ok<bool, String>(true));
    });
  });

  group('getCurrentSession', () {
    test('should log initial message', () async {
      when(() => authDataSource.getSession(any())).thenAnswer((_) async => const Err(UnknownAppwriteErrorModel()));

      await repository.getCurrentSession();

      verify(() => logger.debug('Fetching current session...')).called(1);
    });

    group('should log and fail if auth data source fails', () {
      for (final errorMessage in ['4Sx', 'ILi']) {
        test(errorMessage, () async {
          final unknownAppwriteErrorModel = UnknownAppwriteErrorModel(message: errorMessage);

          when(() => authDataSource.getSession('current')).thenAnswer((_) async => Err(unknownAppwriteErrorModel));

          final result = await repository.getCurrentSession();

          verify(() => logger.error(unknownAppwriteErrorModel.toString())).called(1);
          expect(
            result,
            const Err<CurrentUserSession?, String>(
              'Unable to fetch current session',
            ),
          );
        });
      }
    });

    group('should return expected', () {
      for (final testCase in [
        (_FakeAnonymousSessionModel(), const CurrentUserSession(provider: SessionProvider.anonymous)),
        (
          _FakeEmailSessionModel(),
          const CurrentUserSession(provider: SessionProvider.email),
        ),
        (
          _FakeUnknownSessionModel(),
          const CurrentUserSession(provider: SessionProvider.unknown),
        ),
      ]) {
        test(testCase.toString(), () async {
          when(() => authDataSource.getSession('current')).thenAnswer(
            (_) async => Ok(testCase.$1),
          );

          final result = await repository.getCurrentSession();

          verifyNever(() => logger.error(any()));
          expect(result, Ok<CurrentUserSession?, String>(testCase.$2));
        });
      }
    });
  });
}

class _AuthAppwriteDataSourceMock extends Mock implements AuthAppwriteDataSource {}

class _MockEmailSessionCredentialsModel extends Mock implements EmailSessionCredentialsModel {}

class _MockSessionModel extends Mock implements SessionModel {}

class _MockEmailCredentials extends Mock implements EmailCredentials {
  @override
  final String email = 'ekmjw6';

  @override
  final String password = '^so';
}

class _MockQuizLabLogger extends Mock implements QuizLabLogger {}

class _MockUserModel extends Mock implements UserModel {}

class _FakeEmailSessionModel extends Fake implements SessionModel {
  @override
  final String provider = 'email';
}

class _FakeAnonymousSessionModel extends Fake implements SessionModel {
  @override
  final String provider = 'anonymous';
}

class _FakeUnknownSessionModel extends Fake implements SessionModel {
  @override
  final String provider = '2i17';
}
