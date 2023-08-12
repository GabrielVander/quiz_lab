import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as appwrite_models;
import 'package:appwrite/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/data/data_sources/auth_appwrite_data_source.dart';
import 'package:quiz_lab/core/data/models/email_session_credentials_model.dart';
import 'package:quiz_lab/core/data/models/preferences_model.dart';
import 'package:quiz_lab/core/data/models/session_model.dart';
import 'package:quiz_lab/core/data/models/user_model.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/unit.dart';

void main() {
  late QuizLabLogger logger;
  late Account appwriteAccountServiceMock;

  late AuthAppwriteDataSource dataSource;

  setUp(() {
    logger = _MockQuizLabLogger();
    appwriteAccountServiceMock = _MockAccount();
    dataSource = AuthAppwriteDataSourceImpl(
      logger: logger,
      appwriteAccountService: appwriteAccountServiceMock,
    );
  });

  tearDown(resetMocktailState);

  group(
    'createEmailSession()',
    () {
      group(
        'should call createEmailSession on Appwrite Account service with given '
        'credentials',
        () {
          for (final values in [
            ['', ''],
            ['re7C4cL8', '5*PS66%P'],
          ]) {
            test(values.toString(), () async {
              final email = values[0];
              final password = values[1];

              when(
                () => appwriteAccountServiceMock.createEmailSession(
                  email: any(named: 'email'),
                  password: any(named: 'password'),
                ),
              ).thenThrow(AppwriteException('Er2oG'));

              await dataSource.createEmailSession(
                EmailSessionCredentialsModel(email: email, password: password),
              );

              verify(
                () => appwriteAccountServiceMock.createEmailSession(
                  email: email,
                  password: password,
                ),
              ).called(1);
            });
          }
        },
      );

      test(
        'should fail with exception message if unexpected exception is thrown',
        () async {
          when(
            () => appwriteAccountServiceMock.createEmailSession(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenThrow(AppwriteException('IR4N'));

          final result = await dataSource.createEmailSession(
            const EmailSessionCredentialsModel(
              email: 'x4piF3j',
              password: 'QCK!bQ',
            ),
          );

          expect(result.isErr, true);
        },
      );

      group(
        'should return expected session model',
        () {
          for (final values in [
            [
              appwrite_models.Session(
                $id: 'phnC',
                $createdAt: 'U&JX',
                userId: 'K0qY0',
                expire: '*2B',
                provider: '4JI5Nd0y',
                providerUid: '#qoc3e',
                providerAccessToken: '@*SLcY3',
                providerAccessTokenExpiry: '3%*uvHY8',
                providerRefreshToken: 'sEJS7c',
                ip: 'fUJ32z*Q',
                osCode: 'qzq&D',
                osName: 'e3u6cVJG',
                osVersion: 'a%^M',
                clientType: '*&91B',
                clientCode: 'h*Py',
                clientName: '4AzW1k8y',
                clientVersion: r'$04',
                clientEngine: 'iP*4',
                clientEngineVersion: 'aJix',
                deviceName: '7v39',
                deviceBrand: r'^n$qM5*2',
                deviceModel: '96#76!P',
                countryCode: 'L%J',
                countryName: 'SoZly',
                current: false,
              ),
              const SessionModel(
                userId: 'K0qY0',
                sessionId: 'phnC',
                sessionCreationDate: 'U&JX',
                sessionExpirationDate: '*2B',
                sessionProviderInfo: ProviderInfoModel(
                  accessToken: '@*SLcY3',
                  accessTokenExpirationDate: '3%*uvHY8',
                  name: '4JI5Nd0y',
                  refreshToken: 'sEJS7c',
                  uid: '#qoc3e',
                ),
                ipUsedInSession: 'fUJ32z*Q',
                operatingSystemInfo: OperatingSystemInfoModel(
                  code: 'qzq&D',
                  name: 'e3u6cVJG',
                  version: 'a%^M',
                ),
                clientInfo: ClientInfoModel(
                  type: '*&91B',
                  code: 'h*Py',
                  name: '4AzW1k8y',
                  version: r'$04',
                  engineName: 'iP*4',
                  engineVersion: 'aJix',
                ),
                deviceInfo: DeviceInfoModel(
                  name: '7v39',
                  brand: r'^n$qM5*2',
                  model: '96#76!P',
                ),
                countryCode: 'L%J',
                countryName: 'SoZly',
                isCurrentSession: false,
              )
            ],
            [
              appwrite_models.Session(
                $id: 'R#U!&',
                $createdAt: '7pR^PS%',
                userId: 'yw&C',
                expire: 'y^ac33%f',
                provider: 'mTg^',
                providerUid: 'zCPD62',
                providerAccessToken: 'b47j',
                providerAccessTokenExpiry: r'$@2E',
                providerRefreshToken: 'tK32T2y',
                ip: 'F^7ey^',
                osCode: 'AwU*3n',
                osName: 'wh&',
                osVersion: '4yY#p9*V',
                clientType: 'WTmED6',
                clientCode: 'f^s',
                clientName: r'25k$vV',
                clientVersion: '3sQW9',
                clientEngine: '#6&9gvX',
                clientEngineVersion: r'@gwK$E3m',
                deviceName: 'a^P8q',
                deviceBrand: '6fqG7eH',
                deviceModel: '*qg9',
                countryCode: '65Tf',
                countryName: 'S3fFYu',
                current: true,
              ),
              const SessionModel(
                userId: 'yw&C',
                sessionId: 'R#U!&',
                sessionCreationDate: '7pR^PS%',
                sessionExpirationDate: 'y^ac33%f',
                sessionProviderInfo: ProviderInfoModel(
                  uid: 'zCPD62',
                  accessToken: 'b47j',
                  accessTokenExpirationDate: r'$@2E',
                  name: 'mTg^',
                  refreshToken: 'tK32T2y',
                ),
                ipUsedInSession: 'F^7ey^',
                operatingSystemInfo: OperatingSystemInfoModel(
                  code: 'AwU*3n',
                  name: 'wh&',
                  version: '4yY#p9*V',
                ),
                clientInfo: ClientInfoModel(
                  type: 'WTmED6',
                  code: 'f^s',
                  name: r'25k$vV',
                  version: '3sQW9',
                  engineName: '#6&9gvX',
                  engineVersion: r'@gwK$E3m',
                ),
                deviceInfo: DeviceInfoModel(
                  name: 'a^P8q',
                  brand: '6fqG7eH',
                  model: '*qg9',
                ),
                countryCode: '65Tf',
                countryName: 'S3fFYu',
                isCurrentSession: true,
              )
            ],
          ]) {
            test(values.toString(), () async {
              final appwriteSession = values[0] as appwrite_models.Session;
              final expectedSessionModel = values[1] as SessionModel;

              when(
                () => appwriteAccountServiceMock.createEmailSession(
                  email: any(named: 'email'),
                  password: any(named: 'password'),
                ),
              ).thenAnswer((_) async => appwriteSession);

              final result = await dataSource.createEmailSession(
                const EmailSessionCredentialsModel(
                  email: r'2@$UgaNF',
                  password: 'J!GK',
                ),
              );

              expect(result, Ok<SessionModel, String>(expectedSessionModel));
            });
          }
        },
      );
    },
  );

  group('createAnonymousSession', () {
    test('should log initial message', () {
      when(() => appwriteAccountServiceMock.createAnonymousSession())
          .thenThrow(AppwriteException('rPXyEK6n'));

      dataSource.createAnonymousSession();

      verify(() => logger.debug('Creating anonymous session...')).called(1);
    });

    group('should fail if appwrite account service throws', () {
      for (final errorMessage in ['L8l6', 'ZrBcC0']) {
        test(errorMessage, () async {
          final exception = AppwriteException(errorMessage);

          when(() => appwriteAccountServiceMock.createAnonymousSession())
              .thenThrow(exception);

          final result = await dataSource.createAnonymousSession();

          verify(() => logger.error(exception.toString())).called(1);
          expect(
            result,
            const Err<Unit, String>('Unable to create anonymous session'),
          );
        });
      }
    });

    test('should succeed if appwrite account service succeeds', () async {
      when(() => appwriteAccountServiceMock.createAnonymousSession())
          .thenAnswer((_) async => _MockSession());

      final result = await dataSource.createAnonymousSession();

      verify(() => logger.debug('Anonymous session created successfully'))
          .called(1);
      expect(result, const Ok<Unit, String>(unit));
    });
  });

  group('getCurrentUser', () {
    test('should log initial message', () async {
      when(() => appwriteAccountServiceMock.get())
          .thenThrow(AppwriteException('4rvOY'));

      await dataSource.getCurrentUser();

      verify(() => logger.debug('Fetching user information...')).called(1);
    });

    group('should fail if appwrite account service throws', () {
      for (final errorMessage in ['EPV5xh', 'qHGM3da2']) {
        test(errorMessage, () async {
          final exception = AppwriteException(errorMessage);

          when(() => appwriteAccountServiceMock.get()).thenThrow(exception);

          final result = await dataSource.getCurrentUser();

          verify(() => logger.error(exception.toString())).called(1);
          expect(
            result,
            const Err<UserModel, String>('Unable to fetch user information'),
          );
        });
      }
    });

    test('should fail if user mapping fails', () async {
      when(() => appwriteAccountServiceMock.get())
          .thenAnswer((_) async => _MockUser());

      final result = await dataSource.getCurrentUser();

      verify(() => logger.error(any())).called(1);
      expect(
        result,
        const Err<UserModel, String>('Unable to map user information'),
      );
    });

    test('should succeed', () async {
      final user = _MockUser();
      final preferences = _MockPreferences();
      final preferencesData = <String, dynamic>{
        'qo1b9': 'U11u0MaW',
        'oRQ': 783
      };

      when(() => user.$id).thenReturn(r'$id');
      when(() => user.$createdAt).thenReturn(r'$createdAt');
      when(() => user.$updatedAt).thenReturn(r'$updatedAt');
      when(() => user.name).thenReturn('name');
      when(() => user.email).thenReturn('email');
      when(() => user.phone).thenReturn('phone');
      when(() => user.prefs).thenReturn(preferences);
      when(() => user.registration).thenReturn('registration');
      when(() => user.status).thenReturn(false);
      when(() => user.phoneVerification).thenReturn(false);
      when(() => user.passwordUpdate).thenReturn('passwordUpdate');
      when(() => user.emailVerification).thenReturn(true);
      when(() => preferences.data).thenReturn(preferencesData);
      when(() => appwriteAccountServiceMock.get())
          .thenAnswer((_) async => user);

      final result = await dataSource.getCurrentUser();

      verifyNever(() => logger.error(any()));
      verify(() => logger.debug('User information fetched successfully'))
          .called(1);
      expect(
        result,
        Ok<UserModel, String>(
          UserModel(
            $id: r'$id',
            $createdAt: r'$createdAt',
            $updatedAt: r'$updatedAt',
            name: 'name',
            registration: 'registration',
            status: false,
            passwordUpdate: 'passwordUpdate',
            email: 'email',
            phone: 'phone',
            emailVerification: true,
            phoneVerification: false,
            prefs: PreferencesModel(data: preferencesData),
          ),
        ),
      );
    });
  });
}

class _MockAccount extends Mock implements Account {}

class _MockSession extends Mock implements Session {}

class _MockQuizLabLogger extends Mock implements QuizLabLogger {}

class _MockUser extends Mock implements User {}

class _MockPreferences extends Mock implements Preferences {}
