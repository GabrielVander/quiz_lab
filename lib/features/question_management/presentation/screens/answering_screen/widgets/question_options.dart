import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:quiz_lab/core/presentation/themes/light_theme.dart';
import 'package:quiz_lab/features/question_management/presentation/screens/answering_screen/bloc/answering_screen_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/screens/answering_screen/widgets/loading.dart';

class QuestionOptions extends StatelessWidget {
  const QuestionOptions({required this.cubit, super.key});

  final AnsweringScreenCubit cubit;

  @override
  Widget build(BuildContext context) {
    return HookBuilder(
      builder: (context) {
        final state = useBlocBuilder(cubit, buildWhen: (current) => current is QuestionDisplayAnswersUpdated);

        if (state is QuestionDisplayAnswersUpdated) {
          return _QuestionOptionsDisplay(cubit: cubit, options: state.value);
        }

        return const SimpleLoading();
      },
    );
  }
}

class _QuestionOptionsDisplay extends StatelessWidget {
  const _QuestionOptionsDisplay({
    required this.cubit,
    required this.options,
  });

  final AnsweringScreenCubit cubit;
  final List<QuestionAnswerInfo> options;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: options.length,
      separatorBuilder: (context, index) => const SizedBox(height: 15),
      itemBuilder: (context, index) => _QuestionSingleOption(
        cubit: cubit,
        info: options[index],
      ),
    );
  }
}

class _QuestionSingleOption extends StatelessWidget {
  const _QuestionSingleOption({
    required this.cubit,
    required this.info,
  });

  final AnsweringScreenCubit cubit;
  final QuestionAnswerInfo info;

  @override
  Widget build(BuildContext context) {
    return HookBuilder(
      builder: (context) {
        final state = useBlocBuilder(
          cubit,
          buildWhen: (current) => current is QuestionDisplayShowResult,
        );

        final showResult = state is QuestionDisplayShowResult;
        final showCorrectAnswer = showResult && state.correctAnswerId == info.id;
        final showIncorrectAnswer = showResult && state.selectedAnswerId == info.id;

        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 2),
            color: showCorrectAnswer
                ? Theme.of(context).themeColors.mainColors.success.withOpacity(0.2)
                : showIncorrectAnswer
                    ? Theme.of(context).themeColors.mainColors.error.withOpacity(0.2)
                    : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                _TristateCheckbox(cubit: cubit, optionId: info.id),
                Flexible(
                  child: Text(
                    info.title,
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
    required this.cubit,
    required this.optionId,
  });

  final AnsweringScreenCubit cubit;
  final String optionId;

  @override
  Widget build(BuildContext context) {
    final state = useBlocBuilder(
      cubit,
      buildWhen: (current) => current is QuestionDisplayShowResult,
    );

    final showResult = state is QuestionDisplayShowResult;

    if (showResult && state.correctAnswerId == optionId) {
      return const _CorrectCheckbox();
    }

    if (showResult && state.selectedAnswerId == optionId) {
      return const _IncorrectCheckbox();
    }

    return _StandardCheckbox(
      cubit: cubit,
      optionId: optionId,
      disabled: showResult,
    );
  }
}

class _StandardCheckbox extends HookWidget {
  const _StandardCheckbox({
    required this.cubit,
    required this.optionId,
    this.disabled = false,
  });

  final AnsweringScreenCubit cubit;
  final String optionId;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final state = useBlocBuilder(
      cubit,
      buildWhen: (current) => current is QuestionDisplayAnswerOptionWasSelected,
    );

    return _CustomCheckbox(
      value: !disabled && state is QuestionDisplayAnswerOptionWasSelected && state.id == optionId,
      onChanged: ({newValue}) => cubit.onOptionSelected(optionId),
    );
  }
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
