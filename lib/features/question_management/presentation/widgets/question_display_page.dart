import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:quiz_lab/core/presentation/widgets/difficulty_color.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/question_display/question_display_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/question_display/view_models/question_display_view_model.dart';
import 'package:quiz_lab/generated/l10n.dart';

class QuestionDisplayPage extends HookWidget {
  const QuestionDisplayPage({
    super.key,
    required this.questionId,
    required this.cubit,
  });

  final QuestionDisplayCubit cubit;
  final String? questionId;

  @override
  Widget build(BuildContext context) {
    final state = useBlocBuilder(cubit);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).questionAnswerPageTitle),
        ),
        body: Builder(
          builder: (context) {
            if (state is QuestionDisplayInitial) {
              cubit.loadQuestion(questionId);
            }

            if (state is QuestionDisplayViewModelSubjectUpdated) {
              return StreamBuilder<QuestionDisplayViewModel>(
                stream: state.subject.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final viewModel = snapshot.data!;

                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: _QuestionDisplay(
                        viewModel: viewModel,
                        onOptionSelected: cubit.onOptionSelected,
                        onAnswer: cubit.onAnswer,
                      ),
                    );
                  }

                  return const _Loading();
                },
              );
            }

            return const _Loading();
          },
        ),
      ),
    );
  }
}

class _QuestionDisplay extends StatelessWidget {
  const _QuestionDisplay({
    required this.viewModel,
    required this.onOptionSelected,
    required this.onAnswer,
  });

  final QuestionDisplayViewModel viewModel;
  final void Function(QuestionDisplayOptionViewModel) onOptionSelected;
  final void Function() onAnswer;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _QuestionTitle(viewModel: viewModel),
        const SizedBox(height: 10),
        _QuestionDifficulty(viewModel: viewModel),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _QuestionDescription(viewModel: viewModel),
              const SizedBox(height: 15),
              _QuestionOptions(
                options: viewModel.options,
                onOptionSelected: onOptionSelected,
              ),
            ],
          ),
        ),
        _AnswerButton(onPressed: onAnswer),
      ],
    );
  }
}

class _AnswerButton extends StatelessWidget {
  const _AnswerButton({
    required this.onPressed,
  });

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Text(
        S.of(context).answerQuestionButtonLabel,
        textScaleFactor: 1.2,
      ),
    );
  }
}

class _QuestionTitle extends StatelessWidget {
  const _QuestionTitle({
    required this.viewModel,
  });

  final QuestionDisplayViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          viewModel.title,
          style: Theme.of(context).textTheme.headline4,
        ),
      ],
    );
  }
}

class _QuestionDifficulty extends StatelessWidget {
  const _QuestionDifficulty({
    required this.viewModel,
  });

  final QuestionDisplayViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DifficultyColor(difficulty: viewModel.difficulty),
        const SizedBox(width: 5),
        Text(
          S.of(context).questionDifficultyValue(viewModel.difficulty),
          style: Theme.of(context).textTheme.bodyText1,
          textScaleFactor: 1.2,
        ),
      ],
    );
  }
}

class _QuestionDescription extends StatelessWidget {
  const _QuestionDescription({
    required this.viewModel,
  });

  final QuestionDisplayViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 200),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 2,
                ),
              ),
              padding: const EdgeInsets.all(10),
              child: Text(
                viewModel.description,
                textScaleFactor: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _QuestionOptions extends StatelessWidget {
  const _QuestionOptions({
    required this.options,
    required this.onOptionSelected,
  });

  final List<QuestionDisplayOptionViewModel> options;
  final void Function(QuestionDisplayOptionViewModel) onOptionSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 2),
      ),
      padding: const EdgeInsets.all(10),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: options.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final option = options[index];

          return _QuestionSingleOption(
            option: option,
            onSelected: onOptionSelected,
          );
        },
      ),
    );
  }
}

class _QuestionSingleOption extends StatelessWidget {
  const _QuestionSingleOption({
    required this.option,
    required this.onSelected,
  });

  final QuestionDisplayOptionViewModel option;
  final void Function(QuestionDisplayOptionViewModel) onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          value: option.isSelected,
          onChanged: (_) => onSelected(option),
        ),
        Text(
          option.title,
          style: Theme.of(context).textTheme.headline6,
        ),
      ],
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
