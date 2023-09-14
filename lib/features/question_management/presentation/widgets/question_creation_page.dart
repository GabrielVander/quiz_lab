import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:quiz_lab/core/presentation/design_system/button/default.dart';
import 'package:quiz_lab/core/presentation/design_system/button/primary.dart';
import 'package:quiz_lab/core/presentation/design_system/button/subtle.dart';
import 'package:quiz_lab/core/presentation/design_system/checkbox/core.dart';
import 'package:quiz_lab/core/presentation/design_system/select/core.dart';
import 'package:quiz_lab/core/presentation/design_system/text_area/core.dart';
import 'package:quiz_lab/core/presentation/design_system/text_field/core.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/breakpoint.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/screen_breakpoints.dart';
import 'package:quiz_lab/core/utils/routes.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/question_creation/question_creation_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/question_creation/view_models/question_creation_view_model.dart';
import 'package:quiz_lab/features/question_management/presentation/shared/widgets/beta_banner_display.dart';
import 'package:quiz_lab/features/question_management/presentation/shared/widgets/difficulty_color.dart';
import 'package:quiz_lab/generated/l10n.dart';

class QuestionCreationPage extends HookWidget {
  const QuestionCreationPage({
    required this.cubit,
    super.key,
  });

  final QuestionCreationCubit cubit;

  @override
  Widget build(BuildContext context) {
    final state = useBlocBuilder(cubit);

    return SafeArea(
      child: Scaffold(
        body: BetaBannerDisplay(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Builder(
              builder: (context) {
                if (state is QuestionCreationInitial) {
                  cubit.load();
                }

                if (state is QuestionCreationGoBack) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (GoRouter.of(context).canPop()) {
                      GoRouter.of(context).pop();
                    } else {
                      GoRouter.of(context).goNamed(Routes.questionsOverview.name);
                    }
                  });
                }

                if (state is QuestionCreationViewModelUpdated) {
                  final viewModel = state.viewModel;

                  if (viewModel.message != null && viewModel.showMessage) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      _showSnackBarMessage(context, viewModel.message!);
                    });
                  }
                }

                return _Body(
                  cubit: cubit,
                  onTitleChanged: cubit.onTitleChanged,
                  onDescriptionChanged: cubit.onDescriptionChanged,
                  onDifficultyChanged: cubit.onDifficultyChanged,
                  onOptionChanged: cubit.onOptionChanged,
                  onToggleOptionIsCorrect: cubit.toggleOptionIsCorrect,
                  onAddOption: cubit.onAddOption,
                  onCreateQuestion: cubit.onCreateQuestion,
                );
              },
            ),
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
      case QuestionCreationMessageType.unableToSaveQuestion:
        message = S.of(context).questionSavingFailure(viewModel.details ?? '');
      case QuestionCreationMessageType.noCorrectOption:
        message = S.of(context).questionSavingFailureNoCorrectOption;
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
    required this.cubit,
    required this.onTitleChanged,
    required this.onDescriptionChanged,
    required this.onDifficultyChanged,
    required this.onOptionChanged,
    required this.onToggleOptionIsCorrect,
    required this.onAddOption,
    required this.onCreateQuestion,
  });

  final QuestionCreationCubit cubit;
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
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                cubit: cubit,
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
    required this.cubit,
    required this.onTitleChanged,
    required this.onDescriptionChanged,
    required this.onDifficultyChanged,
    required this.onOptionChanged,
    required this.onToggleOptionIsCorrect,
    required this.onAddOption,
    required this.onCreateQuestion,
  });

  final QuestionCreationCubit cubit;
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
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 15),
            _FormSection(
              child: HookBuilder(
                builder: (context) {
                  final state = useBlocBuilder(
                    cubit,
                    buildWhen: (current) => current is QuestionCreationViewModelUpdated,
                  );

                  if (state is QuestionCreationViewModelUpdated) {
                    return _TitleField(
                      viewModel: state.viewModel.title,
                      onChanged: onTitleChanged,
                    );
                  }

                  return const CircularProgressIndicator();
                },
              ),
            ),
            _FormSection(
              child: HookBuilder(
                builder: (context) {
                  final state = useBlocBuilder(
                    cubit,
                    buildWhen: (current) => current is QuestionCreationViewModelUpdated,
                  );

                  if (state is QuestionCreationViewModelUpdated) {
                    return _DescriptionField(
                      viewModel: state.viewModel.description,
                      onChanged: onDescriptionChanged,
                    );
                  }

                  return const CircularProgressIndicator();
                },
              ),
            ),
            _FormSection(
              child: HookBuilder(
                builder: (context) {
                  final state = useBlocBuilder(
                    cubit,
                    buildWhen: (current) => [QuestionCreationHidePublicToggle, QuestionCreationShowPublicToggle]
                        .contains(current.runtimeType),
                  );

                  if (state is QuestionCreationHidePublicToggle) {
                    return _DifficultySelectorDisplay(cubit: cubit);
                  }

                  return Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: _DifficultySelectorDisplay(cubit: cubit),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: _PublicQuestionToggle(cubit: cubit),
                      ),
                    ],
                  );
                },
              ),
            ),
            _FormSection(
              child: HookBuilder(
                builder: (context) {
                  final state = useBlocBuilder(
                    cubit,
                    buildWhen: (current) => current is QuestionCreationViewModelUpdated,
                  );

                  if (state is QuestionCreationViewModelUpdated) {
                    return _Options(
                      viewModels: state.viewModel.options,
                      onOptionChanged: onOptionChanged,
                      onToggleOptionIsCorrect: onToggleOptionIsCorrect,
                      onAddOption: state.viewModel.addOptionButtonEnabled ? onAddOption : null,
                    );
                  }

                  return const CircularProgressIndicator();
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                QLDefaultButton.text(
                  onPressed: () => GoRouter.of(context).goNamed(Routes.questionsOverview.name),
                  text: S.of(context).goBackLabel,
                ),
                const SizedBox(
                  width: 15,
                ),
                QLPrimaryButton.text(
                  onPressed: onCreateQuestion,
                  text: S.of(context).createLabel,
                ),
              ],
            ),
          ],
        ),
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
      child: child,
    );
  }
}

class _PublicQuestionToggle extends StatelessWidget {
  const _PublicQuestionToggle({required this.cubit});

  final QuestionCreationCubit cubit;

  @override
  Widget build(BuildContext context) {
    return HookBuilder(
      builder: (context) {
        final state = useBlocBuilder(
          cubit,
          buildWhen: (current) => current is QuestionCreationPublicStatusUpdated,
        );

        return QLCheckbox.standard(
          state: state is QuestionCreationPublicStatusUpdated && state.isPublic
              ? QLCheckboxState.checked
              : QLCheckboxState.unchecked,
          onChanged: (_) => cubit.toggleIsQuestionPublic(),
          labelText: S.of(context).isQuestionPublicLabel,
        );
      },
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

    if (viewModel.isEmpty && viewModel.showErrorMessage) {
      errorMessage = S.of(context).mustBeSetMessage;
    }

    return QLTextField.standard(
      labelText: S.of(context).questionTitleLabel,
      errorMessage: errorMessage,
      onChanged: onChanged,
      textInputAction: TextInputAction.next,
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

    return QLTextArea.standard(
      labelText: S.of(context).questionDescriptionLabel,
      errorMessage: errorMessage,
      onChanged: onChanged,
      maxLines: 20,
      textInputAction: TextInputAction.next,
    );
  }
}

class _DifficultySelectorDisplay extends StatelessWidget {
  const _DifficultySelectorDisplay({required this.cubit});

  final QuestionCreationCubit cubit;

  @override
  Widget build(BuildContext context) {
    return HookBuilder(
      builder: (context) {
        final state = useBlocBuilder(
          cubit,
          buildWhen: (current) => current is QuestionCreationViewModelUpdated,
        );

        if (state is QuestionCreationViewModelUpdated) {
          return _DifficultySelector(
            viewModel: state.viewModel.difficulty,
            onChange: cubit.onDifficultyChanged,
          );
        }

        return const CircularProgressIndicator();
      },
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

    return QLSelect<String>.standard(
      labelText: S.of(context).questionDifficultyLabel,
      errorMessage: errorMessage,
      onChanged: onChange,
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
            const Center(child: _Subtitle()),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
            ),
            QLSubtleButton.text(
              onPressed: onAddOption,
              text: S.of(context).addOptionLabel,
            ),
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
        Flexible(
          flex: 2,
          child: QLTextField.standard(
            onChanged: (v) => onChanged(viewModel.id, v),
            labelText: S.of(context).optionInputLabel,
            errorMessage: errorMessage,
            textInputAction: TextInputAction.next,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Flexible(
          child: QLCheckbox.standard(
            onChanged: (_) => onToggleIsCorrect(viewModel.id),
            state: QLCheckboxState.fromValue(value: viewModel.isCorrect),
            labelText: S.of(context).isOptionCorrectLabel,
          ),
        ),
        // Row(
        //   children: [
        //     Checkbox(
        //       value: viewModel.isCorrect,
        //       onChanged: (_) => onToggleIsCorrect(viewModel.id),
        //     ),
        //     Text(S.of(context).isOptionCorrectLabel),
        //   ],
        // )
      ],
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
