import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:quiz_lab/core/presentation/themes/light_theme.dart';
import 'package:quiz_lab/features/answer_question/ui/screens/question_answering/bloc/question_answering_cubit.dart';

class QuestionOptions extends StatelessWidget {
  const QuestionOptions({
    required this.answers,
    required this.showResult,
    required this.onAnswerSelected,
    super.key,
  });

  final List<AnswerViewModel> answers;
  final bool showResult;
  final void Function(String id) onAnswerSelected;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: answers.length,
      separatorBuilder: (context, index) => const SizedBox(height: 15),
      itemBuilder: (context, index) {
        final answer = answers[index];

        return _QuestionSingleOption(
          key: ValueKey(answer.id),
          answer: answer,
          showAsCorrect: showResult && answer.isCorrect,
          showAsIncorrect: showResult && answer.isSelected,
          isSelected: answer.isSelected,
          onChange: showResult ? null : ({bool? newValue}) => onAnswerSelected(answer.id),
        );
      },
    );
  }
}

class _QuestionSingleOption extends StatelessWidget {
  const _QuestionSingleOption({
    required this.answer,
    required this.showAsCorrect,
    required this.showAsIncorrect,
    required this.isSelected,
    required this.onChange,
    super.key,
  });

  final AnswerViewModel answer;
  final bool showAsCorrect;
  final bool showAsIncorrect;
  final bool isSelected;
  final void Function({bool? newValue})? onChange;

  @override
  Widget build(BuildContext context) {
    return HookBuilder(
      builder: (context) {
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 2),
            color: showAsCorrect
                ? Theme.of(context).themeColors.mainColors.success.withOpacity(0.2)
                : showAsIncorrect
                    ? Theme.of(context).themeColors.mainColors.error.withOpacity(0.2)
                    : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                _TristateCheckbox(
                  optionId: answer.id,
                  showResult: showAsCorrect || showAsIncorrect,
                  isSelected: isSelected,
                  isCorrect: showAsCorrect,
                  isIncorrect: showAsIncorrect,
                  onChange: onChange,
                ),
                Flexible(
                  child: Text(
                    answer.title,
                    style: Theme.of(context).textTheme.titleLarge,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TristateCheckbox extends HookWidget {
  const _TristateCheckbox({
    required this.optionId,
    required this.showResult,
    required this.isSelected,
    required this.isCorrect,
    required this.isIncorrect,
    required this.onChange,
  });

  final String optionId;
  final bool showResult;
  final bool isSelected;
  final bool isCorrect;
  final bool isIncorrect;
  final void Function({bool? newValue})? onChange;

  @override
  Widget build(BuildContext context) {
    if (showResult && isCorrect) {
      return const _CorrectCheckbox();
    }

    if (showResult && isIncorrect) {
      return const _IncorrectCheckbox();
    }

    return _StandardCheckbox(
      optionId: optionId,
      disabled: showResult,
      selected: isSelected,
      onChange: onChange,
    );
  }
}

class _StandardCheckbox extends HookWidget {
  const _StandardCheckbox({
    required this.onChange,
    required this.optionId,
    required this.selected,
    this.disabled = false,
  });

  final void Function({bool? newValue})? onChange;
  final String optionId;
  final bool disabled;
  final bool selected;

  @override
  Widget build(BuildContext context) => _CustomCheckbox(
        value: !disabled && selected,
        onChanged: onChange,
      );
}

class _CorrectCheckbox extends StatelessWidget {
  const _CorrectCheckbox();

  @override
  Widget build(BuildContext context) {
    return _CustomCheckbox(
      value: true,
      onChanged: ({bool? newValue}) {},
      activeColor: Theme.of(context).themeColors.mainColors.success,
    );
  }
}

class _IncorrectCheckbox extends StatelessWidget {
  const _IncorrectCheckbox();

  @override
  Widget build(BuildContext context) {
    return _CustomCheckbox(
      value: true,
      onChanged: ({bool? newValue}) {},
      isError: true,
    );
  }
}

class _CustomCheckbox extends HookWidget {
  const _CustomCheckbox({
    required this.onChanged,
    this.value = false,
    this.isError = false,
    this.activeColor,
  });

  final bool? value;
  final void Function({bool? newValue})? onChanged;
  final bool isError;
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      value: value,
      onChanged: onChanged != null ? (v) => onChanged!(newValue: v) : null,
      activeColor: activeColor,
      isError: isError,
    );
  }
}
