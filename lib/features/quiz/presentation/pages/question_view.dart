import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/breakpoint.dart';
import 'package:quiz_lab/core/utils/responsiveness_utils/screen_breakpoints.dart';
import 'package:quiz_lab/features/quiz/presentation/manager/question_creation/question_creation_cubit.dart';
import 'package:quiz_lab/features/quiz/presentation/view_models/question_creation.dart';

class QuestionView extends StatelessWidget {
  const QuestionView({
    super.key,
    required this.dependencyInjection,
  });

  final DependencyInjection dependencyInjection;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Body(
            cubit: dependencyInjection.get<QuestionCreationCubit>(),
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
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
              Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  viewModel: state.viewModel,
                  onShortDescriptionChange: cubit.onShortDescriptionUpdate,
                  onDescriptionChange: cubit.onDescriptionUpdate,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () => cubit.createQuestion(context),
            child: const Text('Create'),
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
      'Create Question',
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
  });

  final QuestionCreationViewModel viewModel;
  final void Function(String newValue) onShortDescriptionChange;
  final void Function(String newValue) onDescriptionChange;

  @override
  Widget build(BuildContext context) {
    return Column(
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
        const Options(),
      ],
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
        labelText: 'Short Description',
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
        labelText: 'Description',
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
  });

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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Subtitle(),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            const Option(),
            const Option(),
            const Option(),
            const Option(),
            const Option(),
            const Option(),
            const Option(),
            const Option(),
            const Option(),
            const Option(),
            const Option(),
            OutlinedButton(onPressed: () {}, child: const Text('Add Option'))
          ],
        ),
      ),
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
      'Options',
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

class Option extends StatelessWidget {
  const Option({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Option #',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Row(
          children: [
            Checkbox(value: false, onChanged: (bool? _) {}),
            const Text('Is Correct')
          ],
        )
      ],
    );
  }
}
