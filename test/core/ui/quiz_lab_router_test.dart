import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_lab/core/ui/quiz_lab_router.dart';
import 'package:quiz_lab/features/answer_question/ui/screens/question_answering/bloc/question_answering_cubit.dart';
import 'package:quiz_lab/features/application_information/ui/bloc/version_display/version_display_cubit.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/check_if_user_is_logged_in_use_case.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/login_cubit/login_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/network/network_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/question_creation/question_creation_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/questions_overview/questions_overview_cubit.dart';

void main() {
  late NetworkCubit networkCubit;
  late BottomNavigationCubit bottomNavigationCubit;
  late QuestionAnsweringCubit questionDisplayCubit;
  late QuestionCreationCubit questionCreationCubit;
  late QuestionsOverviewCubit questionsOverviewCubit;
  late LoginCubit loginPageCubit;
  late CheckIfUserIsLoggedInUseCase checkIfUserIsLoggedInUseCase;
  late VersionDisplayCubit versionDisplayCubit;

  late QuizLabRouter router;

  setUp(() {
    networkCubit = _MockNetworkCubit();
    bottomNavigationCubit = _MockBottomNavigationCubit();
    questionDisplayCubit = _MockQuestionDisplayCubit();
    questionCreationCubit = _MockQuestionCreationCubit();
    questionsOverviewCubit = _MockQuestionsOverviewCubit();
    loginPageCubit = _MockLoginPageCubit();
    checkIfUserIsLoggedInUseCase = _MockCheckIfUserIsLoggedInUseCase();
    versionDisplayCubit = _MockVersionDisplayCubit();

    router = QuizLabRouterImpl(
      networkCubit: networkCubit,
      bottomNavigationCubit: bottomNavigationCubit,
      questionDisplayCubit: questionDisplayCubit,
      questionCreationCubit: questionCreationCubit,
      questionsOverviewCubit: questionsOverviewCubit,
      loginPageCubit: loginPageCubit,
      checkIfUserIsLoggedInUseCase: checkIfUserIsLoggedInUseCase,
      versionDisplayCubit: versionDisplayCubit,
    );
  });

  tearDown(resetMocktailState);

  group('should return GoRouter objects', () {
    test('routeInformationProvider', () {
      expect(
        router.routeInformationProvider,
        isA<GoRouteInformationProvider>(),
      );
    });

    test('routeInformationParser', () {
      expect(router.routeInformationParser, isA<GoRouteInformationParser>());
    });

    test('routerDelegate', () {
      expect(router.routerDelegate, isA<GoRouterDelegate>());
    });
  });
}

class _MockNetworkCubit extends Mock implements NetworkCubit {}

class _MockBottomNavigationCubit extends Mock implements BottomNavigationCubit {}

class _MockQuestionDisplayCubit extends Mock implements QuestionAnsweringCubit {}

class _MockQuestionCreationCubit extends Mock implements QuestionCreationCubit {}

class _MockQuestionsOverviewCubit extends Mock implements QuestionsOverviewCubit {}

class _MockLoginPageCubit extends Mock implements LoginCubit {}

class _MockCheckIfUserIsLoggedInUseCase extends Mock implements CheckIfUserIsLoggedInUseCase {}

class _MockVersionDisplayCubit extends Mock implements VersionDisplayCubit {}
