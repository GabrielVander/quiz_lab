import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' hide Account;
import 'package:flutter_parameterized_test/flutter_parameterized_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:quiz_lab/core/data/data_sources/appwrite_data_source.dart';
import 'package:quiz_lab/core/data/data_sources/models/email_session_credentials_model.dart';
import 'package:quiz_lab/core/data/data_sources/models/session_model.dart';

void main() {
  late Account appwriteAccountServiceMock;

  late AppwriteDataSource dataSource;

  setUp(() {
    appwriteAccountServiceMock = _AccountMock();
    dataSource = AppwriteDataSource(
      appwriteAccountService: appwriteAccountServiceMock,
    );
  });

  group(
    'createEmailSession',
    () {
      parameterizedTest(
        'should call createEmailSession on Appwrite Account service with given '
        'credentials',
        ParameterizedSource.values([
          ['', ''],
          ['re7C4cL8', '5*PS66%P'],
        ]),
        (values) async {
          final email = values[0] as String;
          final password = values[1] as String;

          mocktail
              .when(
                () => appwriteAccountServiceMock.createEmailSession(
                  email: mocktail.any(named: 'email'),
                  password: mocktail.any(named: 'password'),
                ),
              )
              .thenThrow(AppwriteException('Er2oG'));

          await dataSource.createEmailSession(
            EmailSessionCredentialsModel(email: email, password: password),
          );

          mocktail
              .verify(
                () => appwriteAccountServiceMock.createEmailSession(
                  email: email,
                  password: password,
                ),
              )
              .called(1);
        },
      );

      test(
        'should fail with exception message if unexpected exception is thrown',
        () async {
          mocktail
              .when(
                () => appwriteAccountServiceMock.createEmailSession(
                  email: mocktail.any(named: 'email'),
                  password: mocktail.any(named: 'password'),
                ),
              )
              .thenThrow(AppwriteException('IR4N'));

          final result = await dataSource.createEmailSession(
            const EmailSessionCredentialsModel(
              email: 'x4piF3j',
              password: 'QCK!bQ',
            ),
          );

          expect(result.isErr, true);
        },
      );

      parameterizedTest(
        'should return expected session model',
        ParameterizedSource.values([
          [
            Session(
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
              sessionProviderInfo: ProviderInfo(
                accessToken: '@*SLcY3',
                accessTokenExpirationDate: '3%*uvHY8',
                name: '4JI5Nd0y',
                refreshToken: 'sEJS7c',
                uid: '#qoc3e',
              ),
              ipUsedInSession: 'fUJ32z*Q',
              operatingSystemInfo: OperatingSystemInfo(
                code: 'qzq&D',
                name: 'e3u6cVJG',
                version: 'a%^M',
              ),
              clientInfo: ClientInfo(
                type: '*&91B',
                code: 'h*Py',
                name: '4AzW1k8y',
                version: r'$04',
                engineName: 'iP*4',
                engineVersion: 'aJix',
              ),
              deviceInfo: DeviceInfo(
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
            Session(
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
              sessionProviderInfo: ProviderInfo(
                uid: 'zCPD62',
                accessToken: 'b47j',
                accessTokenExpirationDate: r'$@2E',
                name: 'mTg^',
                refreshToken: 'tK32T2y',
              ),
              ipUsedInSession: 'F^7ey^',
              operatingSystemInfo: OperatingSystemInfo(
                code: 'AwU*3n',
                name: 'wh&',
                version: '4yY#p9*V',
              ),
              clientInfo: ClientInfo(
                type: 'WTmED6',
                code: 'f^s',
                name: r'25k$vV',
                version: '3sQW9',
                engineName: '#6&9gvX',
                engineVersion: r'@gwK$E3m',
              ),
              deviceInfo: DeviceInfo(
                name: 'a^P8q',
                brand: '6fqG7eH',
                model: '*qg9',
              ),
              countryCode: '65Tf',
              countryName: 'S3fFYu',
              isCurrentSession: true,
            )
          ],
        ]),
        (values) async {
          final appwriteSession = values[0] as Session;
          final expectedSessionModel = values[1] as SessionModel;

          mocktail
              .when(
                () => appwriteAccountServiceMock.createEmailSession(
                  email: mocktail.any(named: 'email'),
                  password: mocktail.any(named: 'password'),
                ),
              )
              .thenAnswer((_) async => appwriteSession);

          final result = await dataSource.createEmailSession(
            const EmailSessionCredentialsModel(
              email: r'2@$UgaNF',
              password: 'J!GK',
            ),
          );

          expect(result.isOk, true);
          expect(result.ok, expectedSessionModel);
          expect(result.ok!.hashCode, expectedSessionModel.hashCode);
        },
      );
    },
  );
}

class _AccountMock extends mocktail.Mock implements Account {}
