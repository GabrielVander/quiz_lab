import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
import 'package:quiz_lab/features/quiz/presentation/manager/assessments_overview/assessments_overview_cubit.dart';
import 'package:quiz_lab/features/quiz/presentation/widgets/page_subtitle.dart';

class AssessmentsPage extends HookWidget {
  const AssessmentsPage({
    super.key,
    required this.dependencyInjection,
  });

  final DependencyInjection dependencyInjection;

  @override
  Widget build(BuildContext context) {
    final cubit = dependencyInjection.get<AssessmentsOverviewCubit>();
    final state = useBlocBuilder(cubit);

    if (state is AssessmentsOverviewInitial) {
      cubit.getAssessments(context);
    }

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            children: const [
              PageSubtitle(title: 'Assessments'),
            ],
          ),
          Expanded(
            child: Content(state: state),
          ),
        ],
      ),
    );
  }
}

class Content extends StatelessWidget {
  const Content({
    super.key,
    required this.state,
  });

  final AssessmentsOverviewState state;

  @override
  Widget build(BuildContext context) {
    if (state is AssessmentsOverviewLoading) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
        ],
      );
    }

    if (state is AssessmentsOverviewLoaded) {
      final assessments = (state as AssessmentsOverviewLoaded).assessments;

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: assessments.map((e) => Text(e.toString())).toList(),
      );
    }

    return Container();
  }
}
