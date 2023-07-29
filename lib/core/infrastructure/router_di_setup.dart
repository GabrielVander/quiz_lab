import 'package:quiz_lab/core/presentation/bloc/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:quiz_lab/core/presentation/bloc/network/network_cubit.dart';
import 'package:quiz_lab/core/presentation/quiz_lab_router.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
import 'package:quiz_lab/features/auth/presentation/bloc/login_page_cubit/login_page_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/question_creation/question_creation_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/questions_overview_cubit.dart';

void routerDiSetup(DependencyInjection di) {
  di.registerBuilder<QuizLabRouter>(
    (i) => QuizLabRouterImpl(
      bottomNavigationCubit: i.get<BottomNavigationCubit>(),
      loginPageCubit: i.get<LoginPageCubit>(),
      questionCreationCubit: i.get<QuestionCreationCubit>(),
      questionsOverviewCubit: i.get<QuestionsOverviewCubit>(),
      networkCubit: i.get<NetworkCubit>(),
    ),
  );
}
