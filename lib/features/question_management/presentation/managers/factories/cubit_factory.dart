import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/factories/use_case_factory.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/question_creation/question_creation_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/mappers/factories/presentation_mapper_factory.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/questions_overview_cubit.dart';

class CubitFactory {
  const CubitFactory({
    required this.dependencyInjection,
  });

  final DependencyInjection dependencyInjection;

  QuestionsOverviewCubit makeQuestionsOverviewCubit() {
    return QuestionsOverviewCubit(
      useCaseFactory: dependencyInjection.get<UseCaseFactory>().ok!,
      mapperFactory: dependencyInjection.get<PresentationMapperFactory>().ok!,
    );
  }

  QuestionCreationCubit makeQuestionCreationCubit() {
    return QuestionCreationCubit(
      useCaseFactory: dependencyInjection.get<UseCaseFactory>().ok!,
    );
  }
}
