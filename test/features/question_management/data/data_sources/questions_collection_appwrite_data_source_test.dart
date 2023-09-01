import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/appwrite_error_model.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/appwrite_permission_model.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/appwrite_question_creation_model.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/appwrite_question_list_model.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/appwrite_question_model.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/appwrite_question_option_model.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/appwrite_realtime_message_model.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/questions_collection_appwrite_data_source.dart';
import 'package:quiz_lab/features/question_management/wrappers/appwrite_wrapper.dart';

void main() {
  late QuizLabLogger logger;
  late Databases databases;
  late AppwriteWrapper appwriteWrapperMock;
  late Realtime realtime;

  late QuestionCollectionAppwriteDataSourceImpl dataSource;

  final expectedAppwriteErrorMappings = [
    (
      AppwriteWrapperUnexpectedFailure(''),
      QuestionsAppwriteDataSourceUnexpectedFailure(''),
    ),
    (
      AppwriteWrapperUnexpectedFailure(r'$4*'),
      QuestionsAppwriteDataSourceUnexpectedFailure(r'$4*'),
    ),
    (
      AppwriteWrapperServiceFailure(const UnknownAppwriteError()),
      QuestionsAppwriteDataSourceAppwriteFailure(
        const UnknownAppwriteError().toString(),
      ),
    ),
    (
      AppwriteWrapperServiceFailure(
        const UnknownAppwriteError(
          type: '',
          message: '',
          code: 0,
        ),
      ),
      QuestionsAppwriteDataSourceAppwriteFailure(
        const UnknownAppwriteError(
          type: '',
          message: '',
          code: 0,
        ).toString(),
      ),
    ),
    (
      AppwriteWrapperServiceFailure(
        const UnknownAppwriteError(
          type: 'FOq',
          message: 'EYzmU%^',
          code: 372,
        ),
      ),
      QuestionsAppwriteDataSourceAppwriteFailure(
        const UnknownAppwriteError(
          type: 'FOq',
          message: 'EYzmU%^',
          code: 372,
        ).toString(),
      ),
    ),
    (
      AppwriteWrapperServiceFailure(
        const GeneralArgumentInvalidAppwriteError(
          message: '',
        ),
      ),
      QuestionsAppwriteDataSourceAppwriteFailure(
        const GeneralArgumentInvalidAppwriteError(
          message: '',
        ).toString(),
      ),
    ),
    (
      AppwriteWrapperServiceFailure(
        const GeneralArgumentInvalidAppwriteError(
          message: 'L7B%927',
        ),
      ),
      QuestionsAppwriteDataSourceAppwriteFailure(
        const GeneralArgumentInvalidAppwriteError(
          message: 'L7B%927',
        ).toString(),
      ),
    ),
    (
      AppwriteWrapperServiceFailure(
        const DatabaseNotFoundAppwriteError(
          message: '',
        ),
      ),
      QuestionsAppwriteDataSourceAppwriteFailure(
        const DatabaseNotFoundAppwriteError(
          message: '',
        ).toString(),
      ),
    ),
    (
      AppwriteWrapperServiceFailure(
        const DatabaseNotFoundAppwriteError(
          message: 'm#6',
        ),
      ),
      QuestionsAppwriteDataSourceAppwriteFailure(
        const DatabaseNotFoundAppwriteError(
          message: 'm#6',
        ).toString(),
      ),
    ),
    (
      AppwriteWrapperServiceFailure(
        const CollectionNotFoundAppwriteError(
          message: '',
        ),
      ),
      QuestionsAppwriteDataSourceAppwriteFailure(
        const CollectionNotFoundAppwriteError(
          message: '',
        ).toString(),
      ),
    ),
    (
      AppwriteWrapperServiceFailure(
        const CollectionNotFoundAppwriteError(
          message: r'$A77j0*',
        ),
      ),
      QuestionsAppwriteDataSourceAppwriteFailure(
        const CollectionNotFoundAppwriteError(
          message: r'$A77j0*',
        ).toString(),
      ),
    ),
    (
      AppwriteWrapperServiceFailure(
        const DocumentNotFoundAppwriteError(
          message: '',
        ),
      ),
      QuestionsAppwriteDataSourceAppwriteFailure(
        const DocumentNotFoundAppwriteError(
          message: '',
        ).toString(),
      ),
    ),
    (
      AppwriteWrapperServiceFailure(
        const DocumentNotFoundAppwriteError(
          message: 'mMke',
        ),
      ),
      QuestionsAppwriteDataSourceAppwriteFailure(
        const DocumentNotFoundAppwriteError(
          message: 'mMke',
        ).toString(),
      ),
    ),
  ];

  setUp(() {
    logger = _MockQuizLabLogger();
    databases = _MockDatabases();
    realtime = _MockRealtime();
    appwriteWrapperMock = _MockAppwriteWrapper();

    dataSource = QuestionCollectionAppwriteDataSourceImpl(
      logger: logger,
      appwriteDatabaseId: 'G3Q',
      appwriteQuestionCollectionId: 'A9MnFkz',
      appwriteWrapper: appwriteWrapperMock,
      databases: databases,
      realtime: realtime,
    );
  });

  tearDown(resetMocktailState);

  group('createSingle', () {
    group('should fail if database throws', () {
      for (final values in [
        (
          '',
          '',
          const AppwriteQuestionCreationModel(
            ownerId: null,
            title: '',
            description: '',
            difficulty: '',
            options: [],
            categories: [],
          ),
          'Noui0k'
        ),
        (
          'Q!3CTr',
          r'^NW8$',
          const AppwriteQuestionCreationModel(
            ownerId: null,
            title: '#7d76V',
            description: r'$7zCt%Z@',
            difficulty: 'k4Y0r9p',
            options: [
              AppwriteQuestionOptionModel(
                description: 'c1jh',
                isCorrect: true,
              ),
              AppwriteQuestionOptionModel(
                description: r'Q5&&n9$',
                isCorrect: false,
              ),
            ],
            categories: [
              't0&',
              'kzBmu',
              'GRNY3!J9',
            ],
          ),
          '41U6UHPC'
        ),
        (
          'jbM3Wi',
          'Fuh#',
          const AppwriteQuestionCreationModel(
            ownerId: null,
            title: 'P7R9',
            description: 'oOx',
            difficulty: '8n34Tg5I',
            options: [
              AppwriteQuestionOptionModel(
                description: 'k1aU7',
                isCorrect: false,
              ),
              AppwriteQuestionOptionModel(
                description: '4kNB',
                isCorrect: false,
              ),
            ],
            categories: [
              '5kF',
              'kegq',
              'dRTs',
            ],
            permissions: [],
          ),
          'UPcKSQJF'
        ),
        (
          'jbM3Wi',
          'Fuh#',
          AppwriteQuestionCreationModel(
            ownerId: null,
            title: 'P7R9',
            description: 'oOx',
            difficulty: '8n34Tg5I',
            options: const [
              AppwriteQuestionOptionModel(
                description: 'k1aU7',
                isCorrect: false,
              ),
              AppwriteQuestionOptionModel(
                description: '4kNB',
                isCorrect: false,
              ),
            ],
            categories: const [
              '5kF',
              'kegq',
              'dRTs',
            ],
            permissions: [
              AppwritePermissionTypeModel.read(
                AppwritePermissionRoleModel.any(),
              ),
              AppwritePermissionTypeModel.read(
                AppwritePermissionRoleModel.guests(),
              ),
              AppwritePermissionTypeModel.read(
                AppwritePermissionRoleModel.users(),
              ),
              AppwritePermissionTypeModel.read(
                AppwritePermissionRoleModel.users(verified: false),
              ),
              AppwritePermissionTypeModel.read(
                AppwritePermissionRoleModel.user(userId: ''),
              ),
              AppwritePermissionTypeModel.read(
                AppwritePermissionRoleModel.user(userId: 'e58&4'),
              ),
              AppwritePermissionTypeModel.read(
                AppwritePermissionRoleModel.user(userId: '', verified: false),
              ),
              AppwritePermissionTypeModel.read(
                AppwritePermissionRoleModel.user(
                  userId: 'd#N',
                  verified: false,
                ),
              ),
              AppwritePermissionTypeModel.read(
                AppwritePermissionRoleModel.team(teamId: ''),
              ),
              AppwritePermissionTypeModel.read(
                AppwritePermissionRoleModel.team(teamId: 'vcx'),
              ),
              AppwritePermissionTypeModel.read(
                AppwritePermissionRoleModel.teamRole(teamId: '', role: ''),
              ),
              AppwritePermissionTypeModel.read(
                AppwritePermissionRoleModel.teamRole(
                  teamId: '*rYi3wP',
                  role: '',
                ),
              ),
              AppwritePermissionTypeModel.read(
                AppwritePermissionRoleModel.teamRole(
                  teamId: '',
                  role: 'WQYWru',
                ),
              ),
              AppwritePermissionTypeModel.read(
                AppwritePermissionRoleModel.teamRole(
                  teamId: 'u65M3r',
                  role: '^g8@',
                ),
              ),
              AppwritePermissionTypeModel.read(
                AppwritePermissionRoleModel.member(membershipId: ''),
              ),
              AppwritePermissionTypeModel.read(
                AppwritePermissionRoleModel.member(membershipId: '#&*5'),
              ),
              AppwritePermissionTypeModel.create(
                AppwritePermissionRoleModel.any(),
              ),
              AppwritePermissionTypeModel.create(
                AppwritePermissionRoleModel.guests(),
              ),
              AppwritePermissionTypeModel.create(
                AppwritePermissionRoleModel.users(),
              ),
              AppwritePermissionTypeModel.create(
                AppwritePermissionRoleModel.users(verified: false),
              ),
              AppwritePermissionTypeModel.create(
                AppwritePermissionRoleModel.user(userId: ''),
              ),
              AppwritePermissionTypeModel.create(
                AppwritePermissionRoleModel.user(userId: 'e58&4'),
              ),
              AppwritePermissionTypeModel.create(
                AppwritePermissionRoleModel.user(userId: '', verified: false),
              ),
              AppwritePermissionTypeModel.create(
                AppwritePermissionRoleModel.user(
                  userId: 'd#N',
                  verified: false,
                ),
              ),
              AppwritePermissionTypeModel.create(
                AppwritePermissionRoleModel.team(teamId: ''),
              ),
              AppwritePermissionTypeModel.create(
                AppwritePermissionRoleModel.team(teamId: 'vcx'),
              ),
              AppwritePermissionTypeModel.create(
                AppwritePermissionRoleModel.teamRole(teamId: '', role: ''),
              ),
              AppwritePermissionTypeModel.create(
                AppwritePermissionRoleModel.teamRole(
                  teamId: '*rYi3wP',
                  role: '',
                ),
              ),
              AppwritePermissionTypeModel.create(
                AppwritePermissionRoleModel.teamRole(
                  teamId: '',
                  role: 'WQYWru',
                ),
              ),
              AppwritePermissionTypeModel.create(
                AppwritePermissionRoleModel.teamRole(
                  teamId: 'u65M3r',
                  role: '^g8@',
                ),
              ),
              AppwritePermissionTypeModel.create(
                AppwritePermissionRoleModel.member(membershipId: ''),
              ),
              AppwritePermissionTypeModel.create(
                AppwritePermissionRoleModel.member(membershipId: '#&*5'),
              ),
              AppwritePermissionTypeModel.update(
                AppwritePermissionRoleModel.any(),
              ),
              AppwritePermissionTypeModel.update(
                AppwritePermissionRoleModel.guests(),
              ),
              AppwritePermissionTypeModel.update(
                AppwritePermissionRoleModel.users(),
              ),
              AppwritePermissionTypeModel.update(
                AppwritePermissionRoleModel.users(verified: false),
              ),
              AppwritePermissionTypeModel.update(
                AppwritePermissionRoleModel.user(userId: ''),
              ),
              AppwritePermissionTypeModel.update(
                AppwritePermissionRoleModel.user(userId: 'e58&4'),
              ),
              AppwritePermissionTypeModel.update(
                AppwritePermissionRoleModel.user(userId: '', verified: false),
              ),
              AppwritePermissionTypeModel.update(
                AppwritePermissionRoleModel.user(
                  userId: 'd#N',
                  verified: false,
                ),
              ),
              AppwritePermissionTypeModel.update(
                AppwritePermissionRoleModel.team(teamId: ''),
              ),
              AppwritePermissionTypeModel.update(
                AppwritePermissionRoleModel.team(teamId: 'vcx'),
              ),
              AppwritePermissionTypeModel.update(
                AppwritePermissionRoleModel.teamRole(teamId: '', role: ''),
              ),
              AppwritePermissionTypeModel.update(
                AppwritePermissionRoleModel.teamRole(
                  teamId: '*rYi3wP',
                  role: '',
                ),
              ),
              AppwritePermissionTypeModel.update(
                AppwritePermissionRoleModel.teamRole(
                  teamId: '',
                  role: 'WQYWru',
                ),
              ),
              AppwritePermissionTypeModel.update(
                AppwritePermissionRoleModel.teamRole(
                  teamId: 'u65M3r',
                  role: '^g8@',
                ),
              ),
              AppwritePermissionTypeModel.update(
                AppwritePermissionRoleModel.member(membershipId: ''),
              ),
              AppwritePermissionTypeModel.update(
                AppwritePermissionRoleModel.member(membershipId: '#&*5'),
              ),
              AppwritePermissionTypeModel.delete(
                AppwritePermissionRoleModel.any(),
              ),
              AppwritePermissionTypeModel.delete(
                AppwritePermissionRoleModel.guests(),
              ),
              AppwritePermissionTypeModel.delete(
                AppwritePermissionRoleModel.users(),
              ),
              AppwritePermissionTypeModel.delete(
                AppwritePermissionRoleModel.users(verified: false),
              ),
              AppwritePermissionTypeModel.delete(
                AppwritePermissionRoleModel.user(userId: ''),
              ),
              AppwritePermissionTypeModel.delete(
                AppwritePermissionRoleModel.user(userId: 'e58&4'),
              ),
              AppwritePermissionTypeModel.delete(
                AppwritePermissionRoleModel.user(userId: '', verified: false),
              ),
              AppwritePermissionTypeModel.delete(
                AppwritePermissionRoleModel.user(
                  userId: 'd#N',
                  verified: false,
                ),
              ),
              AppwritePermissionTypeModel.delete(
                AppwritePermissionRoleModel.team(teamId: ''),
              ),
              AppwritePermissionTypeModel.delete(
                AppwritePermissionRoleModel.team(teamId: 'vcx'),
              ),
              AppwritePermissionTypeModel.delete(
                AppwritePermissionRoleModel.teamRole(teamId: '', role: ''),
              ),
              AppwritePermissionTypeModel.delete(
                AppwritePermissionRoleModel.teamRole(
                  teamId: '*rYi3wP',
                  role: '',
                ),
              ),
              AppwritePermissionTypeModel.delete(
                AppwritePermissionRoleModel.teamRole(
                  teamId: '',
                  role: 'WQYWru',
                ),
              ),
              AppwritePermissionTypeModel.delete(
                AppwritePermissionRoleModel.teamRole(
                  teamId: 'u65M3r',
                  role: '^g8@',
                ),
              ),
              AppwritePermissionTypeModel.delete(
                AppwritePermissionRoleModel.member(membershipId: ''),
              ),
              AppwritePermissionTypeModel.delete(
                AppwritePermissionRoleModel.member(membershipId: '#&*5'),
              ),
              AppwritePermissionTypeModel.write(
                AppwritePermissionRoleModel.any(),
              ),
              AppwritePermissionTypeModel.write(
                AppwritePermissionRoleModel.guests(),
              ),
              AppwritePermissionTypeModel.write(
                AppwritePermissionRoleModel.users(),
              ),
              AppwritePermissionTypeModel.write(
                AppwritePermissionRoleModel.users(verified: false),
              ),
              AppwritePermissionTypeModel.write(
                AppwritePermissionRoleModel.user(userId: ''),
              ),
              AppwritePermissionTypeModel.write(
                AppwritePermissionRoleModel.user(userId: 'e58&4'),
              ),
              AppwritePermissionTypeModel.write(
                AppwritePermissionRoleModel.user(userId: '', verified: false),
              ),
              AppwritePermissionTypeModel.write(
                AppwritePermissionRoleModel.user(
                  userId: 'd#N',
                  verified: false,
                ),
              ),
              AppwritePermissionTypeModel.write(AppwritePermissionRoleModel.team(teamId: '')),
              AppwritePermissionTypeModel.write(AppwritePermissionRoleModel.team(teamId: 'vcx')),
              AppwritePermissionTypeModel.write(AppwritePermissionRoleModel.teamRole(teamId: '', role: '')),
              AppwritePermissionTypeModel.write(AppwritePermissionRoleModel.teamRole(teamId: '*rYi3wP', role: '')),
              AppwritePermissionTypeModel.write(AppwritePermissionRoleModel.teamRole(teamId: '', role: 'WQYWru')),
              AppwritePermissionTypeModel.write(AppwritePermissionRoleModel.teamRole(teamId: 'u65M3r', role: '^g8@')),
              AppwritePermissionTypeModel.write(AppwritePermissionRoleModel.member(membershipId: '')),
              AppwritePermissionTypeModel.write(AppwritePermissionRoleModel.member(membershipId: '#&*5')),
            ],
          ),
          'EeC'
        ),
      ]) {
        test(values.toString(), () async {
          final databaseId = values.$1;
          final collectionId = values.$2;
          final creationModel = values.$3;
          final message = values.$4;
          final exception = Exception(message);

          dataSource
            ..appwriteDatabaseId = databaseId
            ..appwriteQuestionCollectionId = collectionId;

          when(
            () => databases.createDocument(
              collectionId: collectionId,
              databaseId: databaseId,
              documentId: any(named: 'documentId'),
              data: creationModel.toMap(),
              permissions: creationModel.permissions?.map((p) => p.toString()).toList(),
            ),
          ).thenThrow(exception);

          final result = await dataSource.createSingle(creationModel);

          verify(() => logger.error(exception.toString())).called(1);
          expect(result, const Err<AppwriteQuestionModel, String>('Unable to create question on Appwrite'));
        });
      }
    });

    group('should return expected', () {
      for (final values in [
        (
          Document(
            $id: '',
            $collectionId: '',
            $databaseId: '',
            $createdAt: '',
            $updatedAt: '',
            $permissions: [],
            data: {
              'title': '',
              'options': '[]',
              'difficulty': '',
              'description': '',
              'categories': <String>[],
            },
          ),
          const AppwriteQuestionModel(
            id: '',
            title: '',
            options: [],
            difficulty: '',
            description: '',
            categories: [],
            databaseId: '',
            collectionId: '',
            createdAt: '',
            updatedAt: '',
            profile: null,
          )
        ),
        (
          Document(
            $id: 'k2Kao43',
            $collectionId: 'h^NjK84I',
            $databaseId: 'Cxc#Y1Cj',
            $createdAt: '516',
            $updatedAt: 'D3y^k#Hw',
            $permissions: ['sqG', r'Ft3a7I$v', 'KCfj'],
            data: {
              'title': 'v5l!@',
              'options': '['
                  '{"description":"7T5Tm0p","isCorrect":false},'
                  '{"description":"!D@g3","isCorrect":true},'
                  '{"description":"V%#BGZ","isCorrect":false}'
                  ']',
              'difficulty': 'Tw&N9dD',
              'description': 'JLzh',
              'categories': ['p4lM', r'#2$vxpA', 'cWnH2io'],
              'profile_': 'mKdE0u',
            },
          ),
          const AppwriteQuestionModel(
            id: 'k2Kao43',
            title: 'v5l!@',
            options: [
              AppwriteQuestionOptionModel(description: '7T5Tm0p', isCorrect: false),
              AppwriteQuestionOptionModel(description: '!D@g3', isCorrect: true),
              AppwriteQuestionOptionModel(description: 'V%#BGZ', isCorrect: false),
            ],
            difficulty: 'Tw&N9dD',
            description: 'JLzh',
            categories: ['p4lM', r'#2$vxpA', 'cWnH2io'],
            databaseId: 'Cxc#Y1Cj',
            collectionId: 'h^NjK84I',
            createdAt: '516',
            updatedAt: 'D3y^k#Hw',
            profile: 'mKdE0u',
          )
        ),
      ]) {
        test(values.toString(), () async {
          final appwriteDocument = values.$1;
          final expectedModel = values.$2;

          final creationModelMock = _AppwriteQuestionCreationModelMock();

          when(creationModelMock.toMap).thenReturn({});
          when(
            () => databases.createDocument(
              collectionId: any(named: 'collectionId'),
              databaseId: any(named: 'databaseId'),
              documentId: any(named: 'documentId'),
              data: any(named: 'data'),
            ),
          ).thenAnswer((_) async => appwriteDocument);

          final result = await dataSource.createSingle(creationModelMock);

          expect(result, Ok<AppwriteQuestionModel, String>(expectedModel));
        });
      }
    });
  });

  group('deleteSingle', () {
    group(
      'should call Appwrite wrapper correctly',
      () {
        for (final values in [
          ('', '', ''),
          ('G3Q', 'A9MnFkz', 'dN*p'),
        ]) {
          test(values.toString(), () {
            final databaseId = values.$1;
            final collectionId = values.$2;
            final id = values.$3;

            dataSource
              ..appwriteDatabaseId = databaseId
              ..appwriteQuestionCollectionId = collectionId;

            when(
              () => appwriteWrapperMock.deleteDocument(
                collectionId: any(named: 'collectionId'),
                databaseId: any(named: 'databaseId'),
                documentId: any(named: 'documentId'),
              ),
            ).thenAnswer((_) async => Err(AppwriteWrapperUnexpectedFailure('k7^&M')));

            dataSource.deleteSingle(id);

            verify(
              () => appwriteWrapperMock.deleteDocument(
                databaseId: databaseId,
                collectionId: collectionId,
                documentId: id,
              ),
            );
          });
        }
      },
    );

    group(
      'should return expected failure if Appwrite wrapper fails',
      () {
        for (final values in expectedAppwriteErrorMappings) {
          test(values.toString(), () async {
            final wrapperFailure = values.$1;
            final expectedFailure = values.$2;

            when(
              () => appwriteWrapperMock.deleteDocument(
                collectionId: any(named: 'collectionId'),
                databaseId: any(named: 'databaseId'),
                documentId: any(named: 'documentId'),
              ),
            ).thenAnswer((_) async => Err(wrapperFailure));

            final result = await dataSource.deleteSingle('*1Kl!M2q');

            expect(result.isErr, true);
            expect(result.unwrapErr(), expectedFailure);
          });
        }
      },
    );

    test('should return nothing if Appwrite wrapper returns nothing', () async {
      when(
        () => appwriteWrapperMock.deleteDocument(
          collectionId: any(named: 'collectionId'),
          databaseId: any(named: 'databaseId'),
          documentId: any(named: 'documentId'),
        ),
      ).thenAnswer((_) async => const Ok(unit));

      final result = await dataSource.deleteSingle('vJk60VoW');

      expect(result, const Ok<Unit, QuestionsAppwriteDataSourceFailure>(unit));
    });
  });

  group('fetchSingle', () {
    group(
      'should call Appwrite wrapper correctly',
      () {
        for (final values in [('', '', ''), (r'35&Y3$8', '4F28AYf#', 'vX19')]) {
          test(values.toString(), () {
            final databaseId = values.$1;
            final collectionId = values.$2;
            final id = values.$3;

            dataSource
              ..appwriteDatabaseId = databaseId
              ..appwriteQuestionCollectionId = collectionId;

            when(
              () => appwriteWrapperMock.getDocument(
                collectionId: any(named: 'collectionId'),
                databaseId: any(named: 'databaseId'),
                documentId: any(named: 'documentId'),
              ),
            ).thenAnswer(
              (_) async => Err(AppwriteWrapperUnexpectedFailure('k7^&M')),
            );

            dataSource.fetchSingle(id);

            verify(
              () => appwriteWrapperMock.getDocument(
                databaseId: databaseId,
                collectionId: collectionId,
                documentId: id,
              ),
            );
          });
        }
      },
    );

    group(
      'should return expected failure if Appwrite wrapper fails',
      () {
        for (final values in expectedAppwriteErrorMappings) {
          test(values.toString(), () async {
            final wrapperFailure = values.$1;
            final expectedFailure = values.$2;

            when(
              () => appwriteWrapperMock.getDocument(
                collectionId: any(named: 'collectionId'),
                databaseId: any(named: 'databaseId'),
                documentId: any(named: 'documentId'),
              ),
            ).thenAnswer((_) async => Err(wrapperFailure));

            final result = await dataSource.fetchSingle('9m8v3W');

            expect(result.isErr, true);
            expect(result.unwrapErr(), expectedFailure);
          });
        }
      },
    );

    group('should return expected', () {
      for (final values in [
        (
          Document(
            $id: '',
            $collectionId: '',
            $databaseId: '',
            $createdAt: '',
            $updatedAt: '',
            $permissions: [],
            data: {
              'title': '',
              'options': '[]',
              'difficulty': '',
              'description': '',
              'categories': <String>[],
              'profile_': null,
            },
          ),
          const AppwriteQuestionModel(
            id: '',
            title: '',
            options: [],
            difficulty: '',
            description: '',
            categories: [],
            databaseId: '',
            collectionId: '',
            createdAt: '',
            updatedAt: '',
            profile: null,
          )
        ),
        (
          Document(
            $id: 'k2Kao43',
            $collectionId: 'h^NjK84I',
            $databaseId: 'Cxc#Y1Cj',
            $createdAt: '516',
            $updatedAt: 'D3y^k#Hw',
            $permissions: ['sqG', r'Ft3a7I$v', 'KCfj'],
            data: {
              'title': 'v5l!@',
              'options': '['
                  '{"description":"7T5Tm0p","isCorrect":false},'
                  '{"description":"!D@g3","isCorrect":true},'
                  '{"description":"V%#BGZ","isCorrect":false}'
                  ']',
              'difficulty': 'Tw&N9dD',
              'description': 'JLzh',
              'categories': ['p4lM', r'#2$vxpA', 'cWnH2io'],
              'profile_': 'OX8BLEUE',
            },
          ),
          const AppwriteQuestionModel(
            id: 'k2Kao43',
            title: 'v5l!@',
            options: [
              AppwriteQuestionOptionModel(
                description: '7T5Tm0p',
                isCorrect: false,
              ),
              AppwriteQuestionOptionModel(
                description: '!D@g3',
                isCorrect: true,
              ),
              AppwriteQuestionOptionModel(
                description: 'V%#BGZ',
                isCorrect: false,
              ),
            ],
            difficulty: 'Tw&N9dD',
            description: 'JLzh',
            categories: ['p4lM', r'#2$vxpA', 'cWnH2io'],
            databaseId: 'Cxc#Y1Cj',
            collectionId: 'h^NjK84I',
            createdAt: '516',
            updatedAt: 'D3y^k#Hw',
            profile: 'OX8BLEUE',
          )
        ),
      ]) {
        test(values.toString(), () async {
          final appwriteDocument = values.$1;
          final expectedModel = values.$2;

          when(
            () => appwriteWrapperMock.getDocument(
              collectionId: any(named: 'collectionId'),
              databaseId: any(named: 'databaseId'),
              documentId: any(named: 'documentId'),
            ),
          ).thenAnswer((_) async => Ok(appwriteDocument));

          final result = await dataSource.fetchSingle('!K8@');

          expect(result.isOk, true);
          expect(result.unwrap(), expectedModel);
        });
      }
    });
  });

  group('getAllQuestions()', () {
    test('should log initial message', () {
      when(
        () => databases.listDocuments(databaseId: any(named: 'databaseId'), collectionId: any(named: 'collectionId')),
      ).thenAnswer((_) async => DocumentList(total: 0, documents: []));

      dataSource.getAll();

      verify(() => logger.debug('Retrieving all questions from Appwrite...')).called(1);
    });

    for (final testCase in [
      ('dih', 'NTTmo'),
      ('dIRvO6', 'JOP'),
    ]) {
      final databaseId = testCase.$1;
      final collectionId = testCase.$2;

      group('with $databaseId as database id and $collectionId as collection id', () {
        group('should return expected', () {
          for (final values in [
            (DocumentList(total: 0, documents: []), const AppwriteQuestionListModel(total: 0, questions: [])),
            (
              DocumentList(
                total: 1,
                documents: [
                  Document(
                    $id: 'k2Kao43',
                    $collectionId: 'h^NjK84I',
                    $databaseId: 'Cxc#Y1Cj',
                    $createdAt: '516',
                    $updatedAt: 'D3y^k#Hw',
                    $permissions: ['sqG', r'Ft3a7I$v', 'KCfj'],
                    data: {
                      'title': 'v5l!@',
                      'options': '['
                          '{"description":"7T5Tm0p","isCorrect":false},'
                          '{"description":"!D@g3","isCorrect":true},'
                          '{"description":"V%#BGZ","isCorrect":false}'
                          ']',
                      'difficulty': 'Tw&N9dD',
                      'description': 'JLzh',
                      'categories': ['p4lM', r'#2$vxpA', 'cWnH2io'],
                      'profile_': 'f5Z6',
                    },
                  ),
                ],
              ),
              const AppwriteQuestionListModel(
                total: 1,
                questions: [
                  AppwriteQuestionModel(
                    id: 'k2Kao43',
                    title: 'v5l!@',
                    options: [
                      AppwriteQuestionOptionModel(
                        description: '7T5Tm0p',
                        isCorrect: false,
                      ),
                      AppwriteQuestionOptionModel(
                        description: '!D@g3',
                        isCorrect: true,
                      ),
                      AppwriteQuestionOptionModel(
                        description: 'V%#BGZ',
                        isCorrect: false,
                      ),
                    ],
                    difficulty: 'Tw&N9dD',
                    description: 'JLzh',
                    categories: ['p4lM', r'#2$vxpA', 'cWnH2io'],
                    databaseId: 'Cxc#Y1Cj',
                    collectionId: 'h^NjK84I',
                    createdAt: '516',
                    updatedAt: 'D3y^k#Hw',
                    profile: 'f5Z6',
                  ),
                ],
              ),
            ),
          ]) {
            final docList = values.$1;
            final expected = values.$2;

            test('$docList -> Ok($expected)', () async {
              when(() => databases.listDocuments(databaseId: databaseId, collectionId: collectionId))
                  .thenAnswer((_) async => docList);

              dataSource
                ..appwriteDatabaseId = databaseId
                ..appwriteQuestionCollectionId = collectionId;
              final result = await dataSource.getAll();

              expect(result, Ok<AppwriteQuestionListModel, AppwriteErrorModel>(expected));
            });
          }
        });
      });
    }
  });

  group('watchForQuestionCollectionUpdate()', () {
    group('ok', () {
      group(
        'should subscribe to realtime service correctly',
        () {
          for (final refConfig in [
            (
              'EPfM0058',
              '10SC04',
            ),
            (
              'JeGDX7',
              'fm6!',
            ),
          ]) {
            final databaseId = refConfig.$1;
            final collectionId = refConfig.$2;

            test(refConfig.toString(), () async {
              final realtimeSubscriptionMock = _MockRealtimeSubscription();

              when(() => realtimeSubscriptionMock.stream).thenAnswer((_) => const Stream.empty());
              when(() => realtime.subscribe(any())).thenReturn(realtimeSubscriptionMock);

              dataSource
                ..appwriteDatabaseId = databaseId
                ..appwriteQuestionCollectionId = collectionId;
              await dataSource.watchForUpdate();

              verify(
                () => realtime.subscribe([
                  'databases'
                      '.$databaseId'
                      '.collections'
                      '.$collectionId'
                      '.documents'
                ]),
              );
            });
          }
        },
      );

      group(
        '',
        () {
          for (final values in [
            [
              RealtimeMessage(
                events: [],
                payload: {
                  r'$id': '',
                  'title': '',
                  'options': jsonEncode([]),
                  'difficulty': '',
                  'description': '',
                  'categories': <dynamic>[],
                  r'$permissions': <dynamic>[],
                  r'$databaseId': '',
                  r'$collectionId': '',
                  r'$createdAt': '',
                  r'$updatedAt': '',
                },
                channels: [],
                timestamp: '',
              ),
              const AppwriteRealtimeQuestionMessageModel(
                events: [],
                channels: [],
                timestamp: '',
                payload: AppwriteQuestionModel(
                  id: '',
                  title: '',
                  options: [],
                  difficulty: '',
                  description: '',
                  categories: [],
                  databaseId: '',
                  collectionId: '',
                  createdAt: '',
                  updatedAt: '',
                  profile: null,
                ),
              ),
            ],
            [
              RealtimeMessage(
                events: ['&Bp54', r'C*F$!Ah', '*8pg^4'],
                payload: {
                  r'$id': 'k2Kao43',
                  'title': 'v5l!@',
                  'options': jsonEncode([
                    {
                      'description': '7T5Tm0p',
                      'isCorrect': false,
                    },
                    {
                      'description': '!D@g3',
                      'isCorrect': true,
                    },
                    {
                      'description': 'V%#BGZ',
                      'isCorrect': false,
                    },
                  ]),
                  'difficulty': 'Tw&N9dD',
                  'description': 'JLzh',
                  'categories': ['p4lM', r'#2$vxpA', 'cWnH2io'],
                  'profile_': '7XRx',
                  r'$permissions': ['sqG', r'Ft3a7I$v', 'KCfj'],
                  r'$databaseId': 'Cxc#Y1Cj',
                  r'$collectionId': 'h^NjK84I',
                  r'$createdAt': '516',
                  r'$updatedAt': 'D3y^k#Hw',
                },
                channels: ['NR1', '^o58IQ5', 'No854Z0N'],
                timestamp: '29O%1',
              ),
              const AppwriteRealtimeQuestionMessageModel(
                events: ['&Bp54', r'C*F$!Ah', '*8pg^4'],
                channels: ['NR1', '^o58IQ5', 'No854Z0N'],
                timestamp: '29O%1',
                payload: AppwriteQuestionModel(
                  id: 'k2Kao43',
                  title: 'v5l!@',
                  options: [
                    AppwriteQuestionOptionModel(
                      description: '7T5Tm0p',
                      isCorrect: false,
                    ),
                    AppwriteQuestionOptionModel(
                      description: '!D@g3',
                      isCorrect: true,
                    ),
                    AppwriteQuestionOptionModel(
                      description: 'V%#BGZ',
                      isCorrect: false,
                    ),
                  ],
                  difficulty: 'Tw&N9dD',
                  description: 'JLzh',
                  categories: ['p4lM', r'#2$vxpA', 'cWnH2io'],
                  databaseId: 'Cxc#Y1Cj',
                  collectionId: 'h^NjK84I',
                  createdAt: '516',
                  updatedAt: 'D3y^k#Hw',
                  profile: '7XRx',
                ),
              ),
            ],
          ]) {
            test(values.toString(), () async {
              final dummyRealtimeMessage = values[0] as RealtimeMessage;
              final expectedAppwriteRealtimeQuestionMessageModel = values[1] as AppwriteRealtimeQuestionMessageModel;

              final realtimeSubscriptionMock = _MockRealtimeSubscription();

              when(() => realtimeSubscriptionMock.stream).thenAnswer((_) => Stream.value(dummyRealtimeMessage));
              when(() => realtime.subscribe(any())).thenReturn(realtimeSubscriptionMock);

              final result = await dataSource.watchForUpdate();

              expect(result.isOk, true);
              expect(result.unwrap(), emits(expectedAppwriteRealtimeQuestionMessageModel));
            });
          }
        },
      );
    });
  });
}

class _MockAppwriteWrapper extends Mock implements AppwriteWrapper {}

class _AppwriteQuestionCreationModelMock extends Mock implements AppwriteQuestionCreationModel {}

class _MockDatabases extends Mock implements Databases {}

class _MockQuizLabLogger extends Mock implements QuizLabLogger {}

class _MockRealtime extends Mock implements Realtime {}

class _MockRealtimeSubscription extends Mock implements RealtimeSubscription {}
