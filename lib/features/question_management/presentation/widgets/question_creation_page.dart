import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:quiz_lab/core/presentation/widgets/difficulty_color.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/breakpoint.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/screen_breakpoints.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/question_creation/question_creation_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/question_creation/view_models/question_creation.dart';
import 'package:quiz_lab/generated/l10n.dart';

class QuestionCreationPage extends StatelessWidget {
  const QuestionCreationPage({
    super.key,
    required this.cubit,
  });

  final QuestionCreationCubit cubit;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: _Body(cubit: cubit),
        ),
      ),
    );
  }
}

class _Body extends HookWidget {
  const _Body({
    required this.cubit,
  });

  final QuestionCreationCubit cubit;

  @override
  Widget build(BuildContext context) {
    useBlocListener(
      cubit,
      (_, listenedState, ctx) {
        var message = S.of(context).questionSavedSuccessfully;
        var backgroundColor = Colors.green;

        if (listenedState is QuestionCreationHasFailed) {
          message = S.of(context).questionSavingFailure(
                listenedState.details,
              );
          backgroundColor = Colors.red;
        }

        final snackBar = SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          behavior: SnackBarBehavior.floating,
        );

        ScaffoldMessenger.of(ctx).showSnackBar(snackBar);

        if (listenedState is QuestionCreationHasSucceeded) {
          GoRouter.of(ctx).go('/');
        }
      },
      listenWhen: (currentState) => [
        QuestionCreationHasSucceeded,
        QuestionCreationHasFailed
      ].any((Type element) => currentState.runtimeType == element),
    );

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
                cubit: cubit,
                onCreateQuestion: cubit.createQuestion,
                onAddOption: cubit.addOption,
                onIsCorrect: cubit.optionIsCorrect,
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
    required this.onAddOption,
    required this.onIsCorrect,
    required this.onCreateQuestion,
  });

  final QuestionCreationCubit cubit;
  final void Function() onAddOption;
  final void Function(SingleOptionViewModel viewModel) onIsCorrect;
  final void Function() onCreateQuestion;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _FormSection(
            child: _TitleField(cubit: cubit),
          ),
          _FormSection(
            child: _DescriptionField(cubit: cubit),
          ),
          _FormSection(
            child: _DifficultySelector(cubit: cubit),
          ),
          _FormSection(
            child: _Options(
              onAddOption: onAddOption,
              onIsCorrect: onIsCorrect,
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

class _TitleField extends HookWidget {
  const _TitleField({
    required QuestionCreationCubit cubit,
  }) : _cubit = cubit;

  final QuestionCreationCubit _cubit;

  @override
  Widget build(BuildContext context) {
    final state = useBlocBuilder(
      _cubit,
      buildWhen: (currentState) => [
        QuestionCreationTitleIsEmpty,
        QuestionCreationTitleIsValid
      ].any((element) => currentState.runtimeType == element),
    );

    String? errorMessage;
    const enabled = true;

    if (state is QuestionCreationTitleIsEmpty) {
      errorMessage = S.of(context).mustBeSetMessage;
    }

    if (state is QuestionCreationTitleIsValid) {
      errorMessage = null;
    }

    return TextField(
      decoration: InputDecoration(
        labelText: S.of(context).questionTitleLabel,
        border: const OutlineInputBorder(),
        errorText: errorMessage,
      ),
      onChanged: _cubit.onTitleUpdate,
      enabled: enabled,
    );
  }
}

class _DescriptionField extends HookWidget {
  const _DescriptionField({
    required QuestionCreationCubit cubit,
  }) : _cubit = cubit;

  final QuestionCreationCubit _cubit;

  @override
  Widget build(BuildContext context) {
    final state = useBlocBuilder(
      _cubit,
      buildWhen: (currentState) => [
        QuestionCreationDescriptionIsEmpty,
        QuestionCreationDescriptionIsValid
      ].any((element) => currentState.runtimeType == element),
    );

    String? errorMessage;

    if (state is QuestionCreationDescriptionIsEmpty) {
      errorMessage = S.of(context).mustBeSetMessage;
    }

    if (state is QuestionCreationDescriptionIsValid) {
      errorMessage = null;
    }

    return TextField(
      decoration: InputDecoration(
        labelText: S.of(context).questionDescriptionLabel,
        border: const OutlineInputBorder(),
        errorText: errorMessage,
      ),
      onChanged: _cubit.onDescriptionUpdate,
      minLines: 5,
      maxLines: 10,
    );
  }
}

class _Options extends StatelessWidget {
  const _Options({
    required this.onAddOption,
    required this.onIsCorrect,
  });

  final void Function() onAddOption;
  final void Function(SingleOptionViewModel viewModel) onIsCorrect;

  @override
  Widget build(BuildContext context) {
    // final options = <OptionsViewModel>[];

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
                      // children: options
                      //     .map(
                      //       (e) => Padding(
                      //         padding: const EdgeInsets.only(bottom: 5),
                      //         child: _Option(
                      //           key: e.id,
                      //           viewModel: e,
                      //           onIsCorrect: ({required bool value}) =>
                      //               onIsCorrect(e),
                      //         ),
                      //       ),
                      //     )
                      //     .toList(),
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

class _DifficultySelector extends HookWidget {
  const _DifficultySelector({
    required QuestionCreationCubit cubit,
  }) : _cubit = cubit;

  final QuestionCreationCubit _cubit;

  @override
  Widget build(BuildContext context) {
    final state = useBlocBuilder(
      _cubit,
      buildWhen: (currentState) => [
        QuestionCreationDifficultyIsSet,
        QuestionCreationDifficultyIsNotSet
      ].any((element) => currentState.runtimeType == element),
    );

    String? errorMessage;

    if (state is QuestionCreationDifficultyIsNotSet) {
      errorMessage = S.of(context).mustBeSetMessage;
    }

    if (state is QuestionCreationDifficultyIsSet) {
      errorMessage = null;
    }

    final difficulties = [
      'easy',
      'medium',
      'hard',
    ];

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: S.of(context).questionDifficultyLabel,
        border: const OutlineInputBorder(),
        errorText: errorMessage,
      ),
      onChanged: _cubit.onDifficultyUpdate,
      items: difficulties
          .map(
            (d) => DropdownMenuItem(
              value: d,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(S.of(context).questionDifficultyValue(d)),
                  DifficultyColor(difficulty: d),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

// class _Option extends StatelessWidget {
//   const _Option({
//     super.key,
//     required this.viewModel,
//     required this.onIsCorrect,
//   });
//
//   final SingleOptionViewModel viewModel;
//   final void Function({required bool value}) onIsCorrect;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Expanded(
//           child: TextField(
//             decoration: InputDecoration(
//               labelText: S.of(context).optionInputLabel,
//               border: const OutlineInputBorder(),
//             ),
//           ),
//         ),
//         Row(
//           children: [
//             Checkbox(
//               value: viewModel.isCorrect,
//               onChanged: (bool? value) => onIsCorrect(value: value ?? false),
//             ),
//             Text(S.of(context).isOptionCorrectLabel),
//           ],
//         )
//       ],
//     );
//   }
// }

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
