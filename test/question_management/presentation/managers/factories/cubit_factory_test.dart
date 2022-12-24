import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/factories/use_case_factory.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/factories/cubit_factory.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/question_creation/question_creation_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/mappers/factories/presentation_mapper_factory.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/questions_overview_cubit.dart';

void main() {
  late DependencyInjection mockDependencyInjection;

  late CubitFactory cubitFactory;

  setUp(() {
    mockDependencyInjection = _MockDependencyInjection();
    cubitFactory = CubitFactory(
      dependencyInjection: mockDependencyInjection,
    );
  });

  group(
    'makeQuestionsOverviewCubit',
    () {
      test('should return a QuestionsOverviewCubit', () {
        final mockUseCaseFactory = _MockUseCaseFactory();
        final mockMapperFactory = _MockMapperFactory();

        when(
          () => mockDependencyInjection.get<UseCaseFactory>(),
        ).thenReturn(Result.ok(mockUseCaseFactory));

        when(
          () => mockDependencyInjection.get<PresentationMapperFactory>(),
        ).thenReturn(Result.ok(mockMapperFactory));

        final result = cubitFactory.makeQuestionsOverviewCubit();

        expect(result, isA<QuestionsOverviewCubit>());
      });
    },
  );

  group(
    'makeQuestionCreationCubit',
    () {
      test('should return a QuestionCreationCubit', () {
        final mockUseCaseFactory = _MockUseCaseFactory();

        when(
          () => mockDependencyInjection.get<UseCaseFactory>(),
        ).thenReturn(Result.ok(mockUseCaseFactory));

        final result = cubitFactory.makeQuestionCreationCubit();

        expect(result, isA<QuestionCreationCubit>());
      });
    },
  );
}

class _MockUseCaseFactory extends Mock implements UseCaseFactory {}

class _MockMapperFactory extends Mock implements PresentationMapperFactory {}

class _MockDependencyInjection extends Mock implements DependencyInjection {}
