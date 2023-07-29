import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_lab/core/infrastructure/router_di_setup.dart';
import 'package:quiz_lab/core/presentation/bloc/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:quiz_lab/core/presentation/bloc/network/network_cubit.dart';
import 'package:quiz_lab/core/presentation/quiz_lab_router.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
import 'package:quiz_lab/features/auth/domain/use_cases/check_if_user_is_logged_in_use_case.dart';
import 'package:quiz_lab/features/auth/presentation/bloc/login_page_cubit/login_page_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/question_creation/question_creation_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/questions_overview_cubit.dart';

void main() {
  late DependencyInjection dependencyInjection;

  setUp(() {
    dependencyInjection = _DependencyInjectionMock();
  });

  tearDown(resetMocktailState);

  test('QuizLabRouter', () {
    final networkCubit = _MockNetworkCubit();
    final bottomNavigationCubit = _MockBottomNavigationCubit();
    final questionCreationCubit = _MockQuestionCreationCubit();
    final questionsOverviewCubit = _MockQuestionsOverviewCubit();
    final loginPageCubit = _MockLoginPageCubit();
    final checkIfUserIsLoggedInUseCase = _MockCheckIfUserIsLoggedInUseCase();

    when(() => dependencyInjection.get<NetworkCubit>())
        .thenReturn(networkCubit);
    when(() => dependencyInjection.get<BottomNavigationCubit>())
        .thenReturn(bottomNavigationCubit);
    when(() => dependencyInjection.get<QuestionCreationCubit>())
        .thenReturn(questionCreationCubit);
    when(() => dependencyInjection.get<QuestionsOverviewCubit>())
        .thenReturn(questionsOverviewCubit);
    when(() => dependencyInjection.get<LoginPageCubit>())
        .thenReturn(loginPageCubit);
    when(() => dependencyInjection.get<CheckIfUserIsLoggedInUseCase>())
        .thenReturn(checkIfUserIsLoggedInUseCase);

    routerDiSetup(dependencyInjection);

    final captured = verify(
      () => dependencyInjection.registerBuilder<QuizLabRouter>(captureAny()),
    ).captured;

    final builder =
        captured.single as QuizLabRouter Function(DependencyInjection);

    final instance = builder(dependencyInjection);

    expect(
      instance,
      QuizLabRouterImpl(
        networkCubit: networkCubit,
        bottomNavigationCubit: bottomNavigationCubit,
        questionCreationCubit: questionCreationCubit,
        questionsOverviewCubit: questionsOverviewCubit,
        loginPageCubit: loginPageCubit,
        checkIfUserIsLoggedInUseCase: checkIfUserIsLoggedInUseCase,
      ),
    );
  });
}

class _DependencyInjectionMock extends Mock implements DependencyInjection {}

class _MockNetworkCubit extends Mock implements NetworkCubit {}

class _MockBottomNavigationCubit extends Mock
    implements BottomNavigationCubit {}

class _MockQuestionCreationCubit extends Mock
    implements QuestionCreationCubit {}

class _MockQuestionsOverviewCubit extends Mock
    implements QuestionsOverviewCubit {}

class _MockLoginPageCubit extends Mock implements LoginPageCubit {}

class _MockCheckIfUserIsLoggedInUseCase extends Mock
    implements CheckIfUserIsLoggedInUseCase {}
