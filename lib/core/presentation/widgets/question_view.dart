import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooked_bloc/hooked_bloc.dart';

import '../../../generated/l10n.dart';
import '../../common/manager_factory.dart';
import '../../utils/responsiveness_utils/breakpoint.dart';
import '../../utils/responsiveness_utils/screen_breakpoints.dart';
import '../manager/question_creation/question_creation_cubit.dart';
import '../view_models/question_creation.dart';

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
          child: _Body(
            cubit:
                questionCreationCubitResult.unwrap() as QuestionCreationCubit,
          ),
        ),
      ),
    );
  }
}

class _Body extends HookWidget {
  const _Body({
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

    if (state is Success || state is CreationError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showMaterialBanner(
          MaterialBanner(
            content: DecoratedBox(
              decoration: BoxDecoration(
                color: state is Success ? Colors.green : Colors.red,
              ),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state is Success
                          ? S.of(context).noConnection
                          : (state as CreationError).message,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Container(),
            ],
          ),
        );
      });

      cubit.update();
    }

    if (state is QuestionCreationDisplayUpdate) {
      // ScaffoldMessenger.of(context).hideCurrentMaterialBanner();

      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              _PageTitle(),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: _Form(
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

    if (state is Loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Container();
  }
}

class _PageTitle extends StatelessWidget {
  const _PageTitle();

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

class _Form extends StatelessWidget {
  const _Form({
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
                  child: _ShortDescriptionField(
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
                  child: _DescriptionField(
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
                  child: _Options(
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

class _ShortDescriptionField extends StatelessWidget {
  const _ShortDescriptionField({
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

class _DescriptionField extends StatelessWidget {
  const _DescriptionField({
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

class _Options extends StatelessWidget {
  const _Options({
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
                  _Subtitle(),
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
                            child: _Option(
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

class _Option extends StatelessWidget {
  const _Option({
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

class _Subtitle extends StatelessWidget {
  const _Subtitle({
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
