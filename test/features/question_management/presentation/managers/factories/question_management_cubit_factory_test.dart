import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/factories/use_case_factory.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/factories/question_management_cubit_factory.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/question_creation/question_creation_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/question_display/question_display_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/mappers/factories/presentation_mapper_factory.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/questions_overview_cubit.dart';

void main() {
  late UseCaseFactory useCaseFactoryMock;
  late PresentationMapperFactory presentationMapperFactoryMock;

  late QuestionManagementCubitFactory cubitFactory;

  setUp(() {
    useCaseFactoryMock = _MockUseCaseFactory();
    presentationMapperFactoryMock = _PresentationMapperFactoryMock();
    cubitFactory = QuestionManagementCubitFactory(
      useCaseFactory: useCaseFactoryMock,
      presentationMapperFactory: presentationMapperFactoryMock,
    );
  });

  group(
    'makeQuestionsOverviewCubit',
    () {
      test('should return a QuestionsOverviewCubit', () {
        final result = cubitFactory.makeQuestionsOverviewCubit();

        expect(result, isA<QuestionsOverviewCubit>());
      });
    },
  );

  group(
    'makeQuestionCreationCubit',
    () {
      test('should return a QuestionCreationCubit', () {
        final result = cubitFactory.makeQuestionCreationCubit();

        expect(result, isA<QuestionCreationCubit>());
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

class _MockUseCaseFactory extends Mock implements UseCaseFactory {}

class _PresentationMapperFactoryMock extends Mock
    implements PresentationMapperFactory {}
