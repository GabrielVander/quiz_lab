import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/delete_question_use_case.dart';

void main() {
  late QuestionRepository dummyRepository;
  late DeleteQuestionUseCase useCase;

  setUp(() {
    dummyRepository = DummyQuestionRepository();
    useCase = DeleteQuestionUseCase(questionRepository: dummyRepository);
  });

  tearDown(resetMocktailState);

  group('Should call repository correctly', () {
    for (final id in ['', '!ocOs9d', '*k^rVV']) {
      test('Question id $id', () async {
        when(() => dummyRepository.deleteSingle(any()))
            .thenAnswer((_) async => const Result.ok(unit));

        await useCase.execute(id);

        verify(() => dummyRepository.deleteSingle(id)).called(1);
      });
    }
  });
}

class DummyQuestionRepository extends Mock implements QuestionRepository {}
