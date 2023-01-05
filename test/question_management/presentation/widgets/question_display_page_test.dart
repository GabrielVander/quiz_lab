import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:quiz_lab/features/question_management/presentation/managers/question_display/question_display_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/widgets/question_display_page.dart';

void main() {
  late QuestionDisplayCubit mockCubit;

  setUp(() {
    mockCubit = _QuestionDisplayCubitMock();
  });

  testWidgets('should call load on initial state', (WidgetTester tester) async {
    final dummyStream =
        Stream<QuestionDisplayState>.value(QuestionDisplayState.initial());

    mocktail.when(() => mockCubit.stream).thenAnswer((_) => dummyStream);
    mocktail.when(() => mockCubit.load()).thenAnswer((_) {});

    await tester.pumpWidget(
      MaterialApp(
        home: QuestionDisplayPage(cubit: mockCubit, questionId: null),
      ),
    );

    mocktail.verify(() => mockCubit.stream).called(1);
    mocktail.verify(() => mockCubit.load()).called(1);
    mocktail.verifyNoMoreInteractions(mockCubit);
  });
}

class _QuestionDisplayCubitMock extends mocktail.Mock
    implements QuestionDisplayCubit {}
