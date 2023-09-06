import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/resource_uuid_generator.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_difficulty.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/get_single_question_use_case.dart';
import 'package:uuid/uuid.dart';

part 'question_display_state.dart';

class QuestionDisplayCubit extends Cubit<QuestionDisplayState> {
  QuestionDisplayCubit({required this.logger, required this.getSingleQuestionUseCase})
      : super(const QuestionDisplayInitial());

  final QuizLabLogger logger;
  final GetSingleQuestionUseCase getSingleQuestionUseCase;

  List<_AnswerOptionState> _answers = [];

  Future<void> loadQuestion(String? questionId) async {
    logger.debug('Loading question...');

    await _emit(const QuestionDisplayLoading());
    final result = await _getQuestionForId(questionId);

    if (result.isErr) {
      logger.debug('Question loaded successfully');
      await _emit(const QuestionDisplayError());

      return;
    }

    final question = result.unwrap();

    _cacheAnswers(question);
    await _signalTitleUpdate(question);
    await _signalDescriptionUpdate(question);
    await _signalDifficultyUpdate(question);
    await _signalAnswersUpdate(question);
  }

  Future<void> _signalAnswersUpdate(Question question) async {
    await _emit(
      QuestionDisplayAnswersUpdated(
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
    await _emit(QuestionDisplayDescriptionUpdated(value: question.description));
  }

  Future<void> _signalDifficultyUpdate(Question question) async {
    await _emit(QuestionDisplayDifficultyUpdated(value: _mapDifficulty(question.difficulty)));
  }

  Future<void> _signalTitleUpdate(Question question) async {
    await _emit(QuestionDisplayTitleUpdated(value: question.shortDescription));
  }

  Future<void> onOptionSelected(String optionId) async {
    _answers = _answers.map((answer) {
      if (answer.id == optionId) {
        return answer.copyWith(isSelected: !answer.isSelected);
      }

      return answer.copyWith(isSelected: false);
    }).toList();
    await _emit(QuestionDisplayAnswerOptionWasSelected(id: optionId));
    await _emit(const QuestionDisplayAnswerButtonEnabled());
  }

  Future<void> onAnswer() async {
    await _emit(const QuestionDisplayLoading());
    await _emit(const QuestionDisplayHideAnswerButton());

    final correctAnswers = _answers.where((answer) => answer.isCorrect);

    if (correctAnswers.every((answer) => answer.isSelected)) {
      await _emit(const QuestionDisplayQuestionAnsweredCorrectly());
      return;
    }

    await _emit(const QuestionDisplayQuestionAnsweredIncorrectly());
  }

  void onGoHome() => _emit(const QuestionDisplayGoHome());

  Future<void> _emit(QuestionDisplayState state) async {
    emit(state);
    await Future<void>.delayed(const Duration(milliseconds: 10));
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
