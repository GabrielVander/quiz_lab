import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:quiz_lab/core/presentation/bloc/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:quiz_lab/core/presentation/widgets/main_bottom_nav_bar.dart';
import 'package:quiz_lab/core/utils/routes.dart';
import 'package:quiz_lab/generated/l10n.dart';

void main() {
  late GoRouter goRouterMock;
  late S fakeS;
  late AppLocalizationDelegate fakeLocalizationsDelegate;
  late BottomNavigationCubit bottomNavigationCubitMock;
  late Widget widget;

  setUp(() {
    goRouterMock = _GoRouterMock();
    fakeS = _FakeS();
    fakeLocalizationsDelegate = _FakeLocalizationsDelegate(localizations: fakeS);
    bottomNavigationCubitMock = _BottomNavigationCubitMock();

    widget = MaterialApp(
      home: InheritedGoRouter(
        goRouter: goRouterMock,
        child: Localizations(
          locale: const Locale('en'),
          delegates: [
            fakeLocalizationsDelegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
          child: Scaffold(
            body: MainBottomNavBar(
              bottomNavigationCubit: bottomNavigationCubitMock,
            ),
          ),
        ),
      ),
    );
  });

  tearDown(mocktail.resetMocktailState);

  testWidgets('should render correctly', (tester) async {
    mocktail.when(() => bottomNavigationCubitMock.stream).thenAnswer(
          (_) => const Stream.empty(),
        );
    mocktail.when(() => bottomNavigationCubitMock.state).thenReturn(BottomNavigationInitial());

    await tester.pumpWidget(widget);

    expect(find.byType(BottomNavigationBar), findsOneWidget);

    expect(find.byIcon(Icons.ballot_outlined), findsOneWidget);
    expect(find.byIcon(Icons.question_answer), findsOneWidget);
    expect(find.byIcon(Icons.bar_chart_outlined), findsOneWidget);
  });

  for (final entry in <int, List<IconData>>{
    0: [Icons.ballot, Icons.question_answer_outlined, Icons.bar_chart_outlined],
    1: [Icons.ballot_outlined, Icons.question_answer, Icons.bar_chart_outlined],
    2: [Icons.ballot_outlined, Icons.question_answer_outlined, Icons.bar_chart],
  }.entries) {
    testWidgets('should display expected icons when index ${entry.key}', (widgetTester) async {
      mocktail.when(() => bottomNavigationCubitMock.stream).thenAnswer(
            (_) => const Stream.empty(),
          );
      mocktail
          .when(() => bottomNavigationCubitMock.state)
          .thenReturn(BottomNavigationIndexChangedState(newIndex: entry.key));

      await widgetTester.pumpWidget(widget);

      for (final icon in entry.value) {
        expect(find.byIcon(icon), findsOneWidget);
      }
    });
  }

  for (final route in [
    Routes.assessments,
    Routes.questionsOverview,
    Routes.resultsOverview,
  ]) {
    testWidgets(
      'should navigate to specified route ($route) when cubit emits '
      '[BottomNavigationNavigateToRoute]',
      (widgetTester) async {
        final state = BottomNavigationNavigateToRoute(route: route);

        mocktail.when(() => bottomNavigationCubitMock.stream).thenAnswer(
              (_) => Stream.value(state),
            );
        mocktail.when(() => bottomNavigationCubitMock.state).thenReturn(state);

        await widgetTester.pumpWidget(widget);
        widgetTester.binding.scheduleWarmUpFrame();

        mocktail.verify(() => goRouterMock.goNamed(route.name)).called(1);
      },
    );
  }
}

class _BottomNavigationCubitMock extends mocktail.Mock implements BottomNavigationCubit {}

class _FakeS extends mocktail.Fake implements S {
  @override
  String get assessmentsSectionDisplayName => 'ok8';

  @override
  String get questionsSectionDisplayName => '@Z#XuI';

  @override
  String get resultsSectionDisplayName => '&!yl8';
}

class _FakeLocalizationsDelegate extends mocktail.Fake implements AppLocalizationDelegate {
  _FakeLocalizationsDelegate({required S localizations}) : s = localizations;

  final S s;

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<S> load(Locale locale) => SynchronousFuture(s);

  @override
  Type get type => S;
}

class _GoRouterMock extends mocktail.Mock implements GoRouter {}
