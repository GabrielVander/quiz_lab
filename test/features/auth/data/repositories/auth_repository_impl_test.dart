import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/auth/data/data_sources/auth_appwrite_data_source.dart';
import 'package:quiz_lab/features/auth/data/data_sources/models/email_session_credentials_model.dart';
import 'package:quiz_lab/features/auth/data/data_sources/models/session_model.dart';
import 'package:quiz_lab/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:quiz_lab/features/auth/domain/repository/auth_repository.dart';

void main() {
  late AuthAppwriteDataSource authDataSourceMock;
  late AuthRepositoryImpl repository;

  setUp(() {
    authDataSourceMock = _AuthAppwriteDataSourceMock();
    repository = AuthRepositoryImpl(
      authDataSource: authDataSourceMock,
    );

    mocktail.registerFallbackValue(_FakeEmailSessionCredentialsModel());
  });

  group('loginWithEmailCredentials', () {
    group(
      'should return unexpected error',
      () {
        for (final errorMessage in [
          '',
          'R02!OA',
        ]) {
          test(errorMessage, () async {
            mocktail
                .when(
                  () => authDataSourceMock.createEmailSession(mocktail.any()),
                )
                .thenAnswer((_) async => Err(errorMessage));

            final result = await repository.loginWithEmailCredentials(_FakeEmailCredentials());

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

            mocktail
                .when(
                  () => authDataSourceMock.createEmailSession(
                    EmailSessionCredentialsModel(
                      email: email,
                      password: password,
                    ),
                  ),
                )
                .thenAnswer((_) async => Ok(_FakeSessionModel()));

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
}

class _AuthAppwriteDataSourceMock extends mocktail.Mock
    implements AuthAppwriteDataSource {}

class _FakeEmailSessionCredentialsModel extends mocktail.Fake
    implements EmailSessionCredentialsModel {}

class _FakeSessionModel extends mocktail.Fake implements SessionModel {}

class _FakeEmailCredentials extends mocktail.Fake implements EmailCredentials {
  @override
  final String email = 'ekmjw6';

  @override
  final String password = '^so';
}
