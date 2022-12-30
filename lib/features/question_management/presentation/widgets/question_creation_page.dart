import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:quiz_lab/core/presentation/widgets/difficulty_color.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/breakpoint.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/screen_breakpoints.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/question_creation/question_creation_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/question_creation/view_models/question_creation_view_model.dart';
import 'package:quiz_lab/generated/l10n.dart';

class QuestionCreationPage extends HookWidget {
  const QuestionCreationPage({
    super.key,
    required QuestionCreationCubit cubit,
  }) : _cubit = cubit;

  final QuestionCreationCubit _cubit;

  @override
  Widget build(BuildContext context) {
    final state = useBlocBuilder(_cubit);

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Builder(
            builder: (ctx) {
              if (state is QuestionCreationGoBack) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  GoRouter.of(ctx).go('/');
                });
              }

              if (state is QuestionCreationViewModelSubjectUpdated) {
                final subject = state.viewModelSubject;

                return StreamBuilder<QuestionCreationViewModel>(
                  stream: subject.stream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final viewModel = snapshot.data!;

                    if (viewModel.message != null && viewModel.showMessage) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _showSnackBarMessage(context, viewModel.message!);
                      });
                    }

                    return _Body(
                      viewModel: viewModel,
                      onTitleChanged: _cubit.onTitleChanged,
                      onDescriptionChanged: _cubit.onDescriptionChanged,
                      onDifficultyChanged: _cubit.onDifficultyChanged,
                      onOptionChanged: _cubit.onOptionChanged,
                      onToggleOptionIsCorrect: _cubit.toggleOptionIsCorrect,
                      onAddOption: _cubit.onAddOption,
                      onCreateQuestion: _cubit.onCreateQuestion,
                    );
                  },
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showSnackBarMessage(
    BuildContext context,
    QuestionCreationMessageViewModel viewModel,
  ) {
    String message;
    final backgroundColor = viewModel.isFailure ? Colors.red : Colors.green;

    switch (viewModel.type) {
      case QuestionCreationMessageType.questionSavedSuccessfully:
        message = S.of(context).questionSavedSuccessfully;
        break;
      case QuestionCreationMessageType.unableToSaveQuestion:
        message = S.of(context).questionSavingFailure(viewModel.details ?? '');
        break;
      case QuestionCreationMessageType.noCorrectOption:
        message = S.of(context).questionSavingFailureNoCorrectOption;
        break;
    }

    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.viewModel,
    required this.onTitleChanged,
    required this.onDescriptionChanged,
    required this.onDifficultyChanged,
    required this.onOptionChanged,
    required this.onToggleOptionIsCorrect,
    required this.onAddOption,
    required this.onCreateQuestion,
  });

  final QuestionCreationViewModel viewModel;
  final void Function(String newValue) onTitleChanged;
  final void Function(String newValue) onDescriptionChanged;
  final void Function(String? newValue) onDifficultyChanged;
  final void Function(String id, String newValue) onOptionChanged;
  final void Function(String id) onToggleOptionIsCorrect;
  final void Function() onAddOption;
  final void Function() onCreateQuestion;

  @override
  Widget build(BuildContext context) {
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
          child: Builder(
            builder: (context) {
              return _Form(
                viewModel: viewModel,
                onTitleChanged: onTitleChanged,
                onDescriptionChanged: onDescriptionChanged,
                onDifficultyChanged: onDifficultyChanged,
                onOptionChanged: onOptionChanged,
                onToggleOptionIsCorrect: onToggleOptionIsCorrect,
                onAddOption: onAddOption,
                onCreateQuestion: onCreateQuestion,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PageTitle extends StatelessWidget {
  const _PageTitle();

  @override
  Widget build(BuildContext context) {
    final fontSize = _getFontSize(context);

    return Text(
      key: const ValueKey('newQuestionPageTitle'),
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
    required this.viewModel,
    required this.onTitleChanged,
    required this.onDescriptionChanged,
    required this.onDifficultyChanged,
    required this.onOptionChanged,
    required this.onToggleOptionIsCorrect,
    required this.onAddOption,
    required this.onCreateQuestion,
  });

  final QuestionCreationViewModel viewModel;
  final void Function(String newValue) onTitleChanged;
  final void Function(String newValue) onDescriptionChanged;
  final void Function(String? newValue) onDifficultyChanged;
  final void Function(String id, String newValue) onOptionChanged;
  final void Function(String id) onToggleOptionIsCorrect;
  final void Function() onAddOption;
  final void Function() onCreateQuestion;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _FormSection(
            child: _TitleField(
              viewModel: viewModel.title,
              onChanged: onTitleChanged,
            ),
          ),
          _FormSection(
            child: _DescriptionField(
              viewModel: viewModel.description,
              onChanged: onDescriptionChanged,
            ),
          ),
          _FormSection(
            child: _DifficultySelector(
              viewModel: viewModel.difficulty,
              onChange: onDifficultyChanged,
            ),
          ),
          _FormSection(
            child: _Options(
              viewModels: viewModel.options,
              onOptionChanged: onOptionChanged,
              onToggleOptionIsCorrect: onToggleOptionIsCorrect,
              onAddOption:
                  viewModel.addOptionButtonEnabled ? onAddOption : null,
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

class _FormSection extends StatelessWidget {
  const _FormSection({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField({
    required this.viewModel,
    required this.onChanged,
  });

  final QuestionCreationTitleViewModel viewModel;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    String? errorMessage;
    const enabled = true;

    if (viewModel.isEmpty && viewModel.showErrorMessage) {
      errorMessage = S.of(context).mustBeSetMessage;
    }

    return TextField(
      decoration: InputDecoration(
        labelText: S.of(context).questionTitleLabel,
        border: const OutlineInputBorder(),
        errorText: errorMessage,
      ),
      onChanged: onChanged,
      enabled: enabled,
    );
  }
}

class _DescriptionField extends StatelessWidget {
  const _DescriptionField({
    required this.viewModel,
    required this.onChanged,
  });

  final QuestionCreationDescriptionViewModel viewModel;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    String? errorMessage;

    if (viewModel.isEmpty && viewModel.showErrorMessage) {
      errorMessage = S.of(context).mustBeSetMessage;
    }

    return TextField(
      decoration: InputDecoration(
        labelText: S.of(context).questionDescriptionLabel,
        border: const OutlineInputBorder(),
        errorText: errorMessage,
      ),
      onChanged: onChanged,
      minLines: 5,
      maxLines: 10,
    );
  }
}

class _DifficultySelector extends StatelessWidget {
  const _DifficultySelector({
    required this.viewModel,
    required this.onChange,
  });

  final QuestionCreationDifficultyViewModel viewModel;
  final void Function(String?) onChange;

  @override
  Widget build(BuildContext context) {
    String? errorMessage;

    if (viewModel.isEmpty && viewModel.showErrorMessage) {
      errorMessage = S.of(context).mustBeSetMessage;
    }

    final availableDifficultiesLabels = viewModel.availableValues;

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: S.of(context).questionDifficultyLabel,
        border: const OutlineInputBorder(),
        errorText: errorMessage,
      ),
      onChanged: onChange,
      selectedItemBuilder: (context) => availableDifficultiesLabels
          .map(
            (d) => _DifficultyItem(difficulty: d),
          )
          .toList(),
      items: availableDifficultiesLabels
          .map(
            (d) => DropdownMenuItem(
              value: d,
              child: _DifficultyItem(difficulty: d),
            ),
          )
          .toList(),
    );
  }
}

class _DifficultyItem extends StatelessWidget {
  const _DifficultyItem({required this.difficulty});

  final String difficulty;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DifficultyColor(difficulty: difficulty),
        const SizedBox(width: 10),
        Text(S.of(context).questionDifficultyValue(difficulty)),
      ],
    );
  }
}

class _Options extends StatelessWidget {
  const _Options({
    required this.viewModels,
    required this.onOptionChanged,
    required this.onToggleOptionIsCorrect,
    required this.onAddOption,
  });

  final List<QuestionCreationOptionViewModel> viewModels;
  final void Function(String id, String newValue) onOptionChanged;
  final void Function(String id) onToggleOptionIsCorrect;
  final void Function()? onAddOption;

  @override
  Widget build(BuildContext context) {
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
                  child: Builder(
                    builder: (context) {
                      return SizedBox(
                        height: 230,
                        child: ListView.separated(
                          itemCount: viewModels.length,
                          itemBuilder: (context, index) {
                            final viewModel = viewModels[index];

                            return _Option(
                              viewModel: viewModel,
                              onChanged: onOptionChanged,
                              onToggleIsCorrect: onToggleOptionIsCorrect,
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            _AddOptionButton(onPressed: onAddOption),
          ],
        ),
      ),
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    required this.viewModel,
    required this.onChanged,
    required this.onToggleIsCorrect,
  });

  final QuestionCreationOptionViewModel viewModel;
  final void Function(String id) onToggleIsCorrect;
  final void Function(String id, String newValue) onChanged;

  @override
  Widget build(BuildContext context) {
    String? errorMessage;

    if (viewModel.isEmpty && viewModel.showErrorMessage) {
      errorMessage = S.of(context).mustBeSetMessage;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextField(
            onChanged: (v) => onChanged(viewModel.id, v),
            decoration: InputDecoration(
              labelText: S.of(context).optionInputLabel,
              border: const OutlineInputBorder(),
              errorText: errorMessage,
            ),
          ),
        ),
        Row(
          children: [
            Checkbox(
              value: viewModel.isCorrect,
              onChanged: (_) => onToggleIsCorrect(viewModel.id),
            ),
            Text(S.of(context).isOptionCorrectLabel),
          ],
        )
      ],
    );
  }
}

class _AddOptionButton extends StatelessWidget {
  const _AddOptionButton({
    required this.onPressed,
  });

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Text(S.of(context).addOptionLabel),
    );
  }
}

class _Subtitle extends StatelessWidget {
  const _Subtitle();

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
