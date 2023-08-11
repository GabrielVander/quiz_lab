import 'package:appwrite/appwrite.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_lab/core/data/data_sources/appwrite_data_source.dart';
import 'package:quiz_lab/core/infrastructure/core_di_setup.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
import 'package:quiz_lab/core/utils/logger/impl/quiz_lab_logger_impl.dart';
import 'package:quiz_lab/core/wrappers/appwrite_wrapper.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/questions_collection_appwrite_data_source.dart';
import 'package:quiz_lab/features/question_management/data/repositories/question_repository_impl.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/create_question_use_case.dart';
import 'package:quiz_lab/features/question_management/infrastructure/di_setup.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/question_creation/question_creation_cubit.dart';

void main() {
  late DependencyInjection dependencyInjection;
  late Databases databases;
  late AppwriteWrapper appwriteWrapper;

  setUp(() {
    dependencyInjection = _MockDependencyInjection();
    databases = _MockDatabases();
    appwriteWrapper = _MockAppwriteWrapper();
  });

  test('AppwriteDatabaseIdVariable', () {});

  group('QuestionCollectionAppwriteDataSource', () {
    for (final values in [('a5XM8DQ', 'Gsdt3Zo'), ('3C64', '8Y4dNY')]) {
      final databaseId = values.$1;
      final collectionId = values.$2;

      test('with databaseId: $databaseId', () {
        when(() => dependencyInjection.get<AppwriteDatabaseId>())
            .thenReturn(AppwriteDatabaseId(value: databaseId));
        when(() => dependencyInjection.get<AppwriteQuestionCollectionId>())
            .thenReturn(AppwriteQuestionCollectionId(value: collectionId));
        when(() => dependencyInjection.get<Databases>()).thenReturn(databases);
        when(() => dependencyInjection.get<AppwriteWrapper>())
            .thenReturn(appwriteWrapper);

        questionManagementDiSetup(dependencyInjection);

        final captor = verify(
          () => dependencyInjection
              .registerBuilder<QuestionCollectionAppwriteDataSource>(
            captureAny(),
          ),
        ).captured;

        final builder = captor.single;

        expect(
          builder,
          isA<
              QuestionCollectionAppwriteDataSourceImpl Function(
                DependencyInjection,
              )>(),
        );
        final dataSourceBuilder =
            builder as QuestionCollectionAppwriteDataSourceImpl Function(
          DependencyInjection,
        );

        final dataSource = dataSourceBuilder(dependencyInjection);

        expect(
          dataSource.logger,
          QuizLabLoggerImpl<QuestionCollectionAppwriteDataSourceImpl>(),
        );
        expect(dataSource.appwriteDatabaseId, databaseId);
        expect(dataSource.appwriteQuestionCollectionId, collectionId);
        expect(dataSource.databases, databases);
      });
    }
  });

  test('QuestionRepository', () {
    final appwriteDataSource = _MockAppwriteDataSource();
    final questionCollectionAppwriteDataSource =
        _MockQuestionCollectionAppwriteDataSource();

    when(() => dependencyInjection.get<AppwriteDataSource>())
        .thenReturn(appwriteDataSource);
    when(() => dependencyInjection.get<QuestionCollectionAppwriteDataSource>())
        .thenReturn(questionCollectionAppwriteDataSource);

    questionManagementDiSetup(dependencyInjection);

    final captor = verify(
      () => dependencyInjection.registerBuilder<QuestionRepository>(
        captureAny(
          that: isA<QuestionRepository Function(DependencyInjection)>(),
        ),
      ),
    ).captured;
    final builder = captor.single;

    final repositoryBuilder =
        builder as QuestionRepository Function(DependencyInjection);

    final repository = repositoryBuilder(dependencyInjection);
    expect(repository, isA<QuestionRepositoryImpl>());
    final repositoryImpl = repository as QuestionRepositoryImpl;

    expect(repositoryImpl.logger, QuizLabLoggerImpl<QuestionRepositoryImpl>());
    expect(
      repositoryImpl.questionsAppwriteDataSource,
      questionCollectionAppwriteDataSource,
    );
    expect(repositoryImpl.appwriteDataSource, appwriteDataSource);
  });

  test('QuestionCreationCubit', () {
    final createQuestionUseCase = _MockCreateQuestionUseCase();

    when(() => dependencyInjection.get<CreateQuestionUseCase>())
        .thenReturn(createQuestionUseCase);

    questionManagementDiSetup(dependencyInjection);

    final builder = verify(
      () => dependencyInjection.registerBuilder<QuestionCreationCubit>(
        captureAny(
          that: isA<QuestionCreationCubit Function(DependencyInjection)>(),
        ),
      ),
    ).captured.single;
    final cubitBuilder =
        builder as QuestionCreationCubit Function(DependencyInjection);

    final cubit = cubitBuilder(dependencyInjection);
    expect(cubit.logger, isA<QuizLabLoggerImpl<QuestionCreationCubit>>());
    expect(cubit.createQuestionUseCase, createQuestionUseCase);
  });
}

class _MockDependencyInjection extends Mock implements DependencyInjection {}

class _MockAppwriteWrapper extends Mock implements AppwriteWrapper {}

class _MockDatabases extends Mock implements Databases {}

class _MockAppwriteDataSource extends Mock implements AppwriteDataSource {}

class _MockQuestionCollectionAppwriteDataSource extends Mock
    implements QuestionCollectionAppwriteDataSource {}

class _MockCreateQuestionUseCase extends Mock
    implements CreateQuestionUseCase {}
