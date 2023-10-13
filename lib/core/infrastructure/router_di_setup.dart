import 'package:quiz_lab/core/presentation/quiz_lab_router.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/check_if_user_is_logged_in_use_case.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/login_page_cubit/login_page_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/network/network_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/question_creation/question_creation_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/questions_overview/questions_overview_cubit.dart';
import 'package:quiz_lab/features/answer_question/ui/screens/question_answering/bloc/question_answering_cubit.dart';

void routerDiSetup(DependencyInjection di) {
  di.registerBuilder<QuizLabRouter>(
    (i) => QuizLabRouterImpl(
      bottomNavigationCubit: i.get<BottomNavigationCubit>(),
      loginPageCubit: i.get<LoginPageCubit>(),
      questionDisplayCubit: i.get<QuestionAnsweringCubit>(),
      questionCreationCubit: i.get<QuestionCreationCubit>(),
      questionsOverviewCubit: i.get<QuestionsOverviewCubit>(),
      networkCubit: i.get<NetworkCubit>(),
      checkIfUserIsLoggedInUseCase: i.get<CheckIfUserIsLoggedInUseCase>(),
    ),
  );
}
