import 'package:quiz_lab/features/question_management/domain/use_cases/factories/use_case_factory.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/question_creation/question_creation_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/question_display/question_display_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/mappers/factories/presentation_mapper_factory.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/questions_overview_cubit.dart';

class QuestionManagementCubitFactory {
  const QuestionManagementCubitFactory({
    required QuestionCreationCubit questionCreationCubit,
    required QuestionsOverviewCubit questionsOverviewCubit,
    required this.useCaseFactory,
    required this.presentationMapperFactory,
  })  : _questionCreationCubit = questionCreationCubit,
        _questionsOverviewCubit = questionsOverviewCubit;

  final QuestionCreationCubit _questionCreationCubit;
  final QuestionsOverviewCubit _questionsOverviewCubit;
  final UseCaseFactory useCaseFactory;
  final PresentationMapperFactory presentationMapperFactory;

  QuestionsOverviewCubit makeQuestionsOverviewCubit() =>
      _questionsOverviewCubit;

  QuestionCreationCubit makeQuestionCreationCubit() => _questionCreationCubit;

  QuestionDisplayCubit makeQuestionDisplayCubit() => QuestionDisplayCubit(
        useCaseFactory: useCaseFactory,
      );
}
