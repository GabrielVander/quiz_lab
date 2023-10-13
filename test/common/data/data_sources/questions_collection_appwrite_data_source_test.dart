import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/common/data/data_sources/questions_collection_appwrite_data_source.dart';
import 'package:quiz_lab/common/data/dto/appwrite_error_dto.dart';
import 'package:quiz_lab/common/data/dto/appwrite_question_dto.dart';
import 'package:quiz_lab/common/data/dto/appwrite_question_list_dto.dart';
import 'package:quiz_lab/common/data/dto/appwrite_realtime_message_dto.dart';
import 'package:quiz_lab/common/data/dto/create_appwrite_question_dto.dart';
import 'package:quiz_lab/common/data/wrappers/appwrite_wrapper.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/dto/appwrite_permission_dto.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/dto/appwrite_question_option_dto.dart';

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
          const CreateAppwriteQuestionDto(
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
          const CreateAppwriteQuestionDto(
            ownerId: null,
            title: '#7d76V',
            description: r'$7zCt%Z@',
            difficulty: 'k4Y0r9p',
            options: [
              AppwriteQuestionOptionDto(
                description: 'c1jh',
                isCorrect: true,
              ),
              AppwriteQuestionOptionDto(
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
          const CreateAppwriteQuestionDto(
            ownerId: null,
            title: 'P7R9',
            description: 'oOx',
            difficulty: '8n34Tg5I',
            options: [
              AppwriteQuestionOptionDto(
                description: 'k1aU7',
                isCorrect: false,
              ),
              AppwriteQuestionOptionDto(
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
          CreateAppwriteQuestionDto(
            ownerId: null,
            title: 'P7R9',
            description: 'oOx',
            difficulty: '8n34Tg5I',
            options: const [
              AppwriteQuestionOptionDto(
                description: 'k1aU7',
                isCorrect: false,
              ),
              AppwriteQuestionOptionDto(
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
              AppwritePermissionTypeDto.read(
                AppwritePermissionRoleDto.any(),
              ),
              AppwritePermissionTypeDto.read(
                AppwritePermissionRoleDto.guests(),
              ),
              AppwritePermissionTypeDto.read(
                AppwritePermissionRoleDto.users(),
              ),
              AppwritePermissionTypeDto.read(
                AppwritePermissionRoleDto.users(verified: false),
              ),
              AppwritePermissionTypeDto.read(
                AppwritePermissionRoleDto.user(userId: ''),
              ),
              AppwritePermissionTypeDto.read(
                AppwritePermissionRoleDto.user(userId: 'e58&4'),
              ),
              AppwritePermissionTypeDto.read(
                AppwritePermissionRoleDto.user(userId: '', verified: false),
              ),
              AppwritePermissionTypeDto.read(
                AppwritePermissionRoleDto.user(
                  userId: 'd#N',
                  verified: false,
                ),
              ),
              AppwritePermissionTypeDto.read(
                AppwritePermissionRoleDto.team(teamId: ''),
              ),
              AppwritePermissionTypeDto.read(
                AppwritePermissionRoleDto.team(teamId: 'vcx'),
              ),
              AppwritePermissionTypeDto.read(
                AppwritePermissionRoleDto.teamRole(teamId: '', role: ''),
              ),
              AppwritePermissionTypeDto.read(
                AppwritePermissionRoleDto.teamRole(
                  teamId: '*rYi3wP',
                  role: '',
                ),
              ),
              AppwritePermissionTypeDto.read(
                AppwritePermissionRoleDto.teamRole(
                  teamId: '',
                  role: 'WQYWru',
                ),
              ),
              AppwritePermissionTypeDto.read(
                AppwritePermissionRoleDto.teamRole(
                  teamId: 'u65M3r',
                  role: '^g8@',
                ),
              ),
              AppwritePermissionTypeDto.read(
                AppwritePermissionRoleDto.member(membershipId: ''),
              ),
              AppwritePermissionTypeDto.read(
                AppwritePermissionRoleDto.member(membershipId: '#&*5'),
              ),
              AppwritePermissionTypeDto.create(
                AppwritePermissionRoleDto.any(),
              ),
              AppwritePermissionTypeDto.create(
                AppwritePermissionRoleDto.guests(),
              ),
              AppwritePermissionTypeDto.create(
                AppwritePermissionRoleDto.users(),
              ),
              AppwritePermissionTypeDto.create(
                AppwritePermissionRoleDto.users(verified: false),
              ),
              AppwritePermissionTypeDto.create(
                AppwritePermissionRoleDto.user(userId: ''),
              ),
              AppwritePermissionTypeDto.create(
                AppwritePermissionRoleDto.user(userId: 'e58&4'),
              ),
              AppwritePermissionTypeDto.create(
                AppwritePermissionRoleDto.user(userId: '', verified: false),
              ),
              AppwritePermissionTypeDto.create(
                AppwritePermissionRoleDto.user(
                  userId: 'd#N',
                  verified: false,
                ),
              ),
              AppwritePermissionTypeDto.create(
                AppwritePermissionRoleDto.team(teamId: ''),
              ),
              AppwritePermissionTypeDto.create(
                AppwritePermissionRoleDto.team(teamId: 'vcx'),
              ),
              AppwritePermissionTypeDto.create(
                AppwritePermissionRoleDto.teamRole(teamId: '', role: ''),
              ),
              AppwritePermissionTypeDto.create(
                AppwritePermissionRoleDto.teamRole(
                  teamId: '*rYi3wP',
                  role: '',
                ),
              ),
              AppwritePermissionTypeDto.create(
                AppwritePermissionRoleDto.teamRole(
                  teamId: '',
                  role: 'WQYWru',
                ),
              ),
              AppwritePermissionTypeDto.create(
                AppwritePermissionRoleDto.teamRole(
                  teamId: 'u65M3r',
                  role: '^g8@',
                ),
              ),
              AppwritePermissionTypeDto.create(
                AppwritePermissionRoleDto.member(membershipId: ''),
              ),
              AppwritePermissionTypeDto.create(
                AppwritePermissionRoleDto.member(membershipId: '#&*5'),
              ),
              AppwritePermissionTypeDto.update(
                AppwritePermissionRoleDto.any(),
              ),
              AppwritePermissionTypeDto.update(
                AppwritePermissionRoleDto.guests(),
              ),
              AppwritePermissionTypeDto.update(
                AppwritePermissionRoleDto.users(),
              ),
              AppwritePermissionTypeDto.update(
                AppwritePermissionRoleDto.users(verified: false),
              ),
              AppwritePermissionTypeDto.update(
                AppwritePermissionRoleDto.user(userId: ''),
              ),
              AppwritePermissionTypeDto.update(
                AppwritePermissionRoleDto.user(userId: 'e58&4'),
              ),
              AppwritePermissionTypeDto.update(
                AppwritePermissionRoleDto.user(userId: '', verified: false),
              ),
              AppwritePermissionTypeDto.update(
                AppwritePermissionRoleDto.user(
                  userId: 'd#N',
                  verified: false,
                ),
              ),
              AppwritePermissionTypeDto.update(
                AppwritePermissionRoleDto.team(teamId: ''),
              ),
              AppwritePermissionTypeDto.update(
                AppwritePermissionRoleDto.team(teamId: 'vcx'),
              ),
              AppwritePermissionTypeDto.update(
                AppwritePermissionRoleDto.teamRole(teamId: '', role: ''),
              ),
              AppwritePermissionTypeDto.update(
                AppwritePermissionRoleDto.teamRole(
                  teamId: '*rYi3wP',
                  role: '',
                ),
              ),
              AppwritePermissionTypeDto.update(
                AppwritePermissionRoleDto.teamRole(
                  teamId: '',
                  role: 'WQYWru',
                ),
              ),
              AppwritePermissionTypeDto.update(
                AppwritePermissionRoleDto.teamRole(
                  teamId: 'u65M3r',
                  role: '^g8@',
                ),
              ),
              AppwritePermissionTypeDto.update(
                AppwritePermissionRoleDto.member(membershipId: ''),
              ),
              AppwritePermissionTypeDto.update(
                AppwritePermissionRoleDto.member(membershipId: '#&*5'),
              ),
              AppwritePermissionTypeDto.delete(
                AppwritePermissionRoleDto.any(),
              ),
              AppwritePermissionTypeDto.delete(
                AppwritePermissionRoleDto.guests(),
              ),
              AppwritePermissionTypeDto.delete(
                AppwritePermissionRoleDto.users(),
              ),
              AppwritePermissionTypeDto.delete(
                AppwritePermissionRoleDto.users(verified: false),
              ),
              AppwritePermissionTypeDto.delete(
                AppwritePermissionRoleDto.user(userId: ''),
              ),
              AppwritePermissionTypeDto.delete(
                AppwritePermissionRoleDto.user(userId: 'e58&4'),
              ),
              AppwritePermissionTypeDto.delete(
                AppwritePermissionRoleDto.user(userId: '', verified: false),
              ),
              AppwritePermissionTypeDto.delete(
                AppwritePermissionRoleDto.user(
                  userId: 'd#N',
                  verified: false,
                ),
              ),
              AppwritePermissionTypeDto.delete(
                AppwritePermissionRoleDto.team(teamId: ''),
              ),
              AppwritePermissionTypeDto.delete(
                AppwritePermissionRoleDto.team(teamId: 'vcx'),
              ),
              AppwritePermissionTypeDto.delete(
                AppwritePermissionRoleDto.teamRole(teamId: '', role: ''),
              ),
              AppwritePermissionTypeDto.delete(
                AppwritePermissionRoleDto.teamRole(
                  teamId: '*rYi3wP',
                  role: '',
                ),
              ),
              AppwritePermissionTypeDto.delete(
                AppwritePermissionRoleDto.teamRole(
                  teamId: '',
                  role: 'WQYWru',
                ),
              ),
              AppwritePermissionTypeDto.delete(
                AppwritePermissionRoleDto.teamRole(
                  teamId: 'u65M3r',
                  role: '^g8@',
                ),
              ),
              AppwritePermissionTypeDto.delete(
                AppwritePermissionRoleDto.member(membershipId: ''),
              ),
              AppwritePermissionTypeDto.delete(
                AppwritePermissionRoleDto.member(membershipId: '#&*5'),
              ),
              AppwritePermissionTypeDto.write(
                AppwritePermissionRoleDto.any(),
              ),
              AppwritePermissionTypeDto.write(
                AppwritePermissionRoleDto.guests(),
              ),
              AppwritePermissionTypeDto.write(
                AppwritePermissionRoleDto.users(),
              ),
              AppwritePermissionTypeDto.write(
                AppwritePermissionRoleDto.users(verified: false),
              ),
              AppwritePermissionTypeDto.write(
                AppwritePermissionRoleDto.user(userId: ''),
              ),
              AppwritePermissionTypeDto.write(
                AppwritePermissionRoleDto.user(userId: 'e58&4'),
              ),
              AppwritePermissionTypeDto.write(
                AppwritePermissionRoleDto.user(userId: '', verified: false),
              ),
              AppwritePermissionTypeDto.write(
                AppwritePermissionRoleDto.user(
                  userId: 'd#N',
                  verified: false,
                ),
              ),
              AppwritePermissionTypeDto.write(AppwritePermissionRoleDto.team(teamId: '')),
              AppwritePermissionTypeDto.write(AppwritePermissionRoleDto.team(teamId: 'vcx')),
              AppwritePermissionTypeDto.write(AppwritePermissionRoleDto.teamRole(teamId: '', role: '')),
              AppwritePermissionTypeDto.write(AppwritePermissionRoleDto.teamRole(teamId: '*rYi3wP', role: '')),
              AppwritePermissionTypeDto.write(AppwritePermissionRoleDto.teamRole(teamId: '', role: 'WQYWru')),
              AppwritePermissionTypeDto.write(AppwritePermissionRoleDto.teamRole(teamId: 'u65M3r', role: '^g8@')),
              AppwritePermissionTypeDto.write(AppwritePermissionRoleDto.member(membershipId: '')),
              AppwritePermissionTypeDto.write(AppwritePermissionRoleDto.member(membershipId: '#&*5')),
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
          expect(result, const Err<AppwriteQuestionDto, String>('Unable to create question on Appwrite'));
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
          const AppwriteQuestionDto(
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
          const AppwriteQuestionDto(
            id: 'k2Kao43',
            title: 'v5l!@',
            options: [
              AppwriteQuestionOptionDto(description: '7T5Tm0p', isCorrect: false),
              AppwriteQuestionOptionDto(description: '!D@g3', isCorrect: true),
              AppwriteQuestionOptionDto(description: 'V%#BGZ', isCorrect: false),
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

          expect(result, Ok<AppwriteQuestionDto, String>(expectedModel));
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
          const AppwriteQuestionDto(
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
          const AppwriteQuestionDto(
            id: 'k2Kao43',
            title: 'v5l!@',
            options: [
              AppwriteQuestionOptionDto(
                description: '7T5Tm0p',
                isCorrect: false,
              ),
              AppwriteQuestionOptionDto(
                description: '!D@g3',
                isCorrect: true,
              ),
              AppwriteQuestionOptionDto(
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
            (DocumentList(total: 0, documents: []), const AppwriteQuestionListDto(total: 0, questions: [])),
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
              const AppwriteQuestionListDto(
                total: 1,
                questions: [
                  AppwriteQuestionDto(
                    id: 'k2Kao43',
                    title: 'v5l!@',
                    options: [
                      AppwriteQuestionOptionDto(
                        description: '7T5Tm0p',
                        isCorrect: false,
                      ),
                      AppwriteQuestionOptionDto(
                        description: '!D@g3',
                        isCorrect: true,
                      ),
                      AppwriteQuestionOptionDto(
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

              expect(result, Ok<AppwriteQuestionListDto, AppwriteErrorDto>(expected));
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
              const AppwriteRealtimeQuestionMessageDto(
                events: [],
                channels: [],
                timestamp: '',
                payload: AppwriteQuestionDto(
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
              const AppwriteRealtimeQuestionMessageDto(
                events: ['&Bp54', r'C*F$!Ah', '*8pg^4'],
                channels: ['NR1', '^o58IQ5', 'No854Z0N'],
                timestamp: '29O%1',
                payload: AppwriteQuestionDto(
                  id: 'k2Kao43',
                  title: 'v5l!@',
                  options: [
                    AppwriteQuestionOptionDto(
                      description: '7T5Tm0p',
                      isCorrect: false,
                    ),
                    AppwriteQuestionOptionDto(
                      description: '!D@g3',
                      isCorrect: true,
                    ),
                    AppwriteQuestionOptionDto(
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
              final expectedAppwriteRealtimeQuestionMessageModel = values[1] as AppwriteRealtimeQuestionMessageDto;

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

class _AppwriteQuestionCreationModelMock extends Mock implements CreateAppwriteQuestionDto {}

class _MockDatabases extends Mock implements Databases {}

class _MockQuizLabLogger extends Mock implements QuizLabLogger {}

class _MockRealtime extends Mock implements Realtime {}

class _MockRealtimeSubscription extends Mock implements RealtimeSubscription {}
