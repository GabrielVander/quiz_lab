import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/custom_implementations/rust_result.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/resource_uuid_generator.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_difficulty.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/get_single_question_use_case.dart';
import 'package:uuid/uuid.dart';

part 'question_answering_state.dart';

class QuestionAnsweringCubit extends Cubit<AnsweringScreenState> {
  QuestionAnsweringCubit({required this.logger, required this.getSingleQuestionUseCase})
      : super(const AnsweringScreenInitial());

  final QuizLabLogger logger;
  final GetSingleQuestionUseCase getSingleQuestionUseCase;

  List<_AnswerOptionState> _answers = [];

  Future<void> loadQuestion(String? questionId) async {
    logger.debug('Loading question...');

    await _emit(const AnsweringScreenLoading());

    (await (await _getQuestionForId(questionId)).inspectAsync((question) async => _emitQuestion(question)))
        .mapErr((_) => 'Unable to load question')
        .inspectErr(logger.error)
        .inspectErr((error) async => _emit(AnsweringScreenError(message: error)));
  }

  Future<void> _emitQuestion(Question question) async {
    _cacheAnswers(question);
    await _signalTitleUpdate(question);
    await _signalDescriptionUpdate(question);
    await _signalDifficultyUpdate(question);
    await _signalAnswersUpdate(question);
  }

  Future<void> _signalAnswersUpdate(Question question) async {
    await _emit(
      AnsweringScreenAnswersUpdated(
        value: _answers.map((a) => QuestionAnswerInfo(id: a.id, title: a.title)).toList()..shuffle(),
      ),
    );
  }

  void _cacheAnswers(Question question) {
    _answers.clear();
    _answers = question.answerOptions.map((option) {
      final id = const ResourceUuidGenerator(uuid: Uuid()).generate();

      return _AnswerOptionState(id: id, title: option.description, isSelected: false, isCorrect: option.isCorrect);
    }).toList();
  }

  Future<void> _signalDescriptionUpdate(Question question) async {
    await _emit(AnsweringScreenDescriptionUpdated(value: question.description));
  }

  Future<void> _signalDifficultyUpdate(Question question) async {
    await _emit(AnsweringScreenDifficultyUpdated(value: _mapDifficulty(question.difficulty)));
  }

  Future<void> _signalTitleUpdate(Question question) async {
    await _emit(AnsweringScreenTitleUpdated(value: question.shortDescription));
  }

  Future<void> onOptionSelected(String optionId) async {
    _answers = _answers.map((answer) {
      if (answer.id == optionId) {
        return answer.copyWith(isSelected: !answer.isSelected);
      }

      return answer.copyWith(isSelected: false);
    }).toList();
    await _emit(AnsweringScreenAnswerOptionWasSelected(id: optionId));
    await _emit(const AnsweringScreenAnswerButtonEnabled());
  }

  Future<void> onAnswer() async {
    await _emit(const AnsweringScreenHideAnswerButton());

    final correctAnswers = _answers.where((answer) => answer.isCorrect);
    final firstCorrectAnswer = correctAnswers.first.id;
    final firstSelectedAnswer = _answers.firstWhere((answer) => answer.isSelected).id;

    await _emit(
      AnsweringScreenShowResult(
        correctAnswerId: firstCorrectAnswer,
        selectedAnswerId: firstSelectedAnswer,
      ),
    );
  }

  Future<void> _emit(AnsweringScreenState state) async {
    emit(state);
    await Future<void>.delayed(const Duration(milliseconds: 15));
  }

  Future<Result<Question, void>> _getQuestionForId(String? questionId) async =>
      (await getSingleQuestionUseCase.execute(questionId)).mapErr((_) {});

  String _mapDifficulty(QuestionDifficulty difficulty) {
    switch (difficulty) {
      case QuestionDifficulty.easy:
        return 'easy';
      case QuestionDifficulty.medium:
        return 'medium';
      case QuestionDifficulty.hard:
        return 'hard';
      case QuestionDifficulty.unknown:
        return 'unknown';
    }
  }
}

class _AnswerOptionState extends Equatable {
  const _AnswerOptionState({
    required this.id,
    required this.title,
    required this.isSelected,
    required this.isCorrect,
  });

  final String id;
  final String title;
  final bool isSelected;
  final bool isCorrect;

  _AnswerOptionState copyWith({
    String? id,
    String? title,
    bool? isSelected,
    bool? isCorrect,
  }) {
    return _AnswerOptionState(
      id: id ?? this.id,
      title: title ?? this.title,
      isSelected: isSelected ?? this.isSelected,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }

  @override
  List<Object> get props => [id, title, isSelected, isCorrect];
}
