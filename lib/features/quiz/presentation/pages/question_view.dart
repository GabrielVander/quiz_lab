import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/presentation/manager/manager_factory.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/breakpoint.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/screen_breakpoints.dart';
import 'package:quiz_lab/features/quiz/presentation/manager/question_creation/question_creation_cubit.dart';
import 'package:quiz_lab/features/quiz/presentation/view_models/question_creation.dart';
import 'package:quiz_lab/generated/l10n.dart';

class QuestionView extends StatelessWidget {
  const QuestionView({
    super.key,
    required this.managerFactory,
  });

  final ManagerFactory managerFactory;

  @override
  Widget build(BuildContext context) {
    final questionCreationCubitResult = managerFactory.make(
      desiredManager: AvailableManagers.questionCreationCubit,
    );

    if (questionCreationCubitResult.isErr) {
      return Container();
    }

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Body(
            cubit:
                questionCreationCubitResult.unwrap() as QuestionCreationCubit,
          ),
        ),
      ),
    );
  }
}

class Body extends HookWidget {
  const Body({
    super.key,
    required this.cubit,
  });

  final QuestionCreationCubit cubit;

  @override
  Widget build(BuildContext context) {
    final state = useBlocBuilder(cubit);

    if (state is QuestionCreationInitial) {
      cubit.update();
    }

    if (state is QuestionCreationDisplayUpdate) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              PageTitle(),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Form(
              viewModel: state.viewModel,
              onShortDescriptionChange: (value) =>
                  cubit.onShortDescriptionUpdate(context, value),
              onDescriptionChange: (value) =>
                  cubit.onDescriptionUpdate(context, value),
              onCreateQuestion: () => cubit.createQuestion(context),
              onAddOption: cubit.addOption,
              onIsCorrect: cubit.optionIsCorrect,
            ),
          ),
        ],
      );
    }

    return Container();
  }
}

class PageTitle extends StatelessWidget {
  const PageTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final fontSize = _getFontSize(context);

    return Text(
      S.of(context).createQuestionTitle,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  double _getFontSize(BuildContext context) {
    return ScreenBreakpoints.getValueForScreenType<double>(
      context: context,
      map: (p) {
        switch (p.runtimeType) {
          case MobileBreakpoint:
            return 20;
          case TabletBreakpoint:
            return 22;
          case DesktopBreakpoint:
            return 24;
          default:
            return 22;
        }
      },
    );
  }
}

class Form extends StatelessWidget {
  const Form({
    super.key,
    required this.viewModel,
    required this.onShortDescriptionChange,
    required this.onDescriptionChange,
    required this.onAddOption,
    required this.onIsCorrect,
    required this.onCreateQuestion,
  });

  final QuestionCreationViewModel viewModel;
  final void Function(String newValue) onShortDescriptionChange;
  final void Function(String newValue) onDescriptionChange;
  final void Function() onAddOption;
  final void Function(SingleOptionViewModel viewModel) onIsCorrect;
  final void Function() onCreateQuestion;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                Expanded(
                  child: ShortDescriptionField(
                    viewModel: viewModel.shortDescription,
                    onChanged: onShortDescriptionChange,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                Expanded(
                  child: DescriptionField(
                    viewModel: viewModel.description,
                    onChange: onDescriptionChange,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                Expanded(
                  child: Options(
                    viewModel: viewModel.options,
                    onAddOption: onAddOption,
                    onIsCorrect: onIsCorrect,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () => GoRouter.of(context).go('/'),
                child: Text(S.of(context).goBackLabel),
              ),
              const SizedBox(
                width: 15,
              ),
              ElevatedButton(
                onPressed: onCreateQuestion,
                child: Text(S.of(context).createLabel),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ShortDescriptionField extends StatelessWidget {
  const ShortDescriptionField({
    super.key,
    required this.viewModel,
    required this.onChanged,
  });

  final FieldViewModel viewModel;
  final void Function(String newValue) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: S.of(context).questionShortDescriptionLabel,
        border: const OutlineInputBorder(),
        errorText: viewModel.hasError ? viewModel.errorMessage : null,
      ),
      enabled: viewModel.isEnabled,
      onChanged: onChanged,
    );
  }
}

class DescriptionField extends StatelessWidget {
  const DescriptionField({
    super.key,
    required this.viewModel,
    required this.onChange,
  });

  final FieldViewModel viewModel;
  final void Function(String newValue) onChange;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: S.of(context).questionDescriptionLabel,
        border: const OutlineInputBorder(),
        errorText: viewModel.hasError ? viewModel.errorMessage : null,
      ),
      onChanged: onChange,
      minLines: 3,
      maxLines: 3,
    );
  }
}

class Options extends StatelessWidget {
  const Options({
    super.key,
    required this.viewModel,
    required this.onAddOption,
    required this.onIsCorrect,
  });

  final OptionsViewModel viewModel;
  final void Function() onAddOption;
  final void Function(SingleOptionViewModel viewModel) onIsCorrect;

  @override
  Widget build(BuildContext context) {
    final options = viewModel.optionViewModels;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        border: Border.all(),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Subtitle(),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: options
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Option(
                              key: e.id,
                              viewModel: e,
                              onIsCorrect: (bool _) => onIsCorrect(e),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
            OutlinedButton(
              onPressed: onAddOption,
              child: Text(S.of(context).addOptionLabel),
            ),
          ],
        ),
      ),
    );
  }
}

class Option extends StatelessWidget {
  const Option({
    super.key,
    required this.viewModel,
    required this.onIsCorrect,
  });

  final SingleOptionViewModel viewModel;
  final void Function(bool value) onIsCorrect;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              labelText: S.of(context).optionInputLabel,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        Row(
          children: [
            Checkbox(
              value: viewModel.isCorrect,
              onChanged: (bool? value) => onIsCorrect(value ?? false),
            ),
            Text(S.of(context).isOptionCorrectLabel),
          ],
        )
      ],
    );
  }
}

class Subtitle extends StatelessWidget {
  const Subtitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final fontSize = _getFontSize(context);

    return Text(
      S.of(context).optionsTitle,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  double _getFontSize(BuildContext context) {
    return ScreenBreakpoints.getValueForScreenType<double>(
      context: context,
      map: (p) {
        switch (p.runtimeType) {
          case MobileBreakpoint:
            return 16;
          case TabletBreakpoint:
            return 18;
          case DesktopBreakpoint:
            return 20;
          default:
            return 16;
        }
      },
    );
  }
}
