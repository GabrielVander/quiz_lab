import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:quiz_lab/features/question_management/domain/use_cases/factories/use_case_factory.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/factories/question_management_cubit_factory.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/question_creation/question_creation_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/question_display/question_display_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/mappers/factories/presentation_mapper_factory.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/questions_overview_cubit.dart';

void main() {
  late QuestionCreationCubit questionCreationCubitMock;
  late QuestionsOverviewCubit questionsOverviewCubitMock;
  late UseCaseFactory useCaseFactoryMock;
  late PresentationMapperFactory presentationMapperFactoryMock;

  late QuestionManagementCubitFactory cubitFactory;

  setUp(() {
    questionCreationCubitMock = _QuestionCreationCubitMock();
    questionsOverviewCubitMock = _QuestionsOverviewCubitMock();
    useCaseFactoryMock = _UseCaseFactoryMock();
    presentationMapperFactoryMock = _PresentationMapperFactoryMock();
    cubitFactory = QuestionManagementCubitFactory(
      questionCreationCubit: questionCreationCubitMock,
      questionsOverviewCubit: questionsOverviewCubitMock,
      useCaseFactory: useCaseFactoryMock,
      presentationMapperFactory: presentationMapperFactoryMock,
    );
  });

  group(
    'makeQuestionsOverviewCubit',
    () {
      test('should return a QuestionsOverviewCubit', () {
        final result = cubitFactory.makeQuestionsOverviewCubit();

        expect(result, questionsOverviewCubitMock);
      });
    },
  );

  group(
    'makeQuestionCreationCubit',
    () {
      test('should return a QuestionCreationCubit', () {
        final result = cubitFactory.makeQuestionCreationCubit();

        expect(result, questionCreationCubitMock);
      });
    },
  );

  group(
    'makeQuestionDisplayCubit',
    () {
      test('should return a QuestionDisplayCubit', () {
        final result = cubitFactory.makeQuestionDisplayCubit();

        expect(result, isA<QuestionDisplayCubit>());
      });
    },
  );
}

class _UseCaseFactoryMock extends mocktail.Mock implements UseCaseFactory {}

class _PresentationMapperFactoryMock extends mocktail.Mock
    implements PresentationMapperFactory {}

class _QuestionCreationCubitMock extends mocktail.Mock
    implements QuestionCreationCubit {}

class _QuestionsOverviewCubitMock extends mocktail.Mock
    implements QuestionsOverviewCubit {}
