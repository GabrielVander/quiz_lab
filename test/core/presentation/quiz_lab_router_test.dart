import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_lab/core/presentation/bloc/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:quiz_lab/core/presentation/bloc/network/network_cubit.dart';
import 'package:quiz_lab/core/presentation/quiz_lab_router.dart';
import 'package:quiz_lab/features/auth/presentation/bloc/login_page_cubit/login_page_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/question_creation/question_creation_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/questions_overview_cubit.dart';

void main() {
  late NetworkCubit networkCubit;
  late BottomNavigationCubit bottomNavigationCubit;
  late QuestionCreationCubit questionCreationCubit;
  late QuestionsOverviewCubit questionsOverviewCubit;
  late LoginPageCubit loginPageCubit;

  late QuizLabRouter router;

  setUp(() {
    networkCubit = _MockNetworkCubit();
    bottomNavigationCubit = _MockBottomNavigationCubit();
    questionCreationCubit = _MockQuestionCreationCubit();
    questionsOverviewCubit = _MockQuestionsOverviewCubit();
    loginPageCubit = _MockLoginPageCubit();

    router = QuizLabRouterImpl(
      networkCubit: networkCubit,
      bottomNavigationCubit: bottomNavigationCubit,
      questionCreationCubit: questionCreationCubit,
      questionsOverviewCubit: questionsOverviewCubit,
      loginPageCubit: loginPageCubit,
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

class _MockBottomNavigationCubit extends Mock
    implements BottomNavigationCubit {}

class _MockQuestionCreationCubit extends Mock
    implements QuestionCreationCubit {}

class _MockQuestionsOverviewCubit extends Mock
    implements QuestionsOverviewCubit {}

class _MockLoginPageCubit extends Mock implements LoginPageCubit {}
