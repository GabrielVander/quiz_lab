import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/assessments_overview/assessments_overview_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/widgets/assessment_overview.dart';
import 'package:quiz_lab/features/question_management/presentation/widgets/fork_lift_message.dart';
import 'package:quiz_lab/features/question_management/presentation/widgets/page_subtitle.dart';
import 'package:quiz_lab/generated/l10n.dart';

class AssessmentsPage extends HookWidget {
  const AssessmentsPage({
    required this.assessmentsOverviewCubit,
    super.key,
  });

  final AssessmentsOverviewCubit assessmentsOverviewCubit;

  @override
  Widget build(BuildContext context) {
    final state = useBlocBuilder(assessmentsOverviewCubit);

    if (state is AssessmentsOverviewInitial) {
      unawaited(assessmentsOverviewCubit.getAssessments(context));
    }

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                PageSubtitle(
                  title: S.of(context).assessmentsSectionDisplayName,
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: ForkLiftMessage(message: S.of(context).workInProgressMessage),
            ),
          ),
        ],
      ),
    );

    // return Padding(
    //   padding: const EdgeInsets.all(15),
    //   child: Column(
    //     children: [
    //       Padding(
    //         padding: const EdgeInsets.only(bottom: 10),
    //         child: Row(
    //           children: [
    //             PageSubtitle(
    //               title: S.of(context).assessmentsSectionDisplayName,
    //             ),
    //           ],
    //         ),
    //       ),
    //       Expanded(
    //         child: Content(state: state),
    //       ),
    //     ],
    //   ),
    // );
  }
}

class Content extends StatelessWidget {
  const Content({
    required this.state,
    super.key,
  });

  final AssessmentsOverviewState state;

  @override
  Widget build(BuildContext context) {
    if (state is AssessmentsOverviewLoading) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
        ],
      );
    }

    if (state is AssessmentsOverviewLoaded) {
      final assessments = (state as AssessmentsOverviewLoaded).assessments;

      return ListView.separated(
        itemCount: assessments.length,
        itemBuilder: (BuildContext context, int index) => AssessmentOverview(
          key: UniqueKey(),
          assessment: assessments[index],
        ),
        separatorBuilder: (BuildContext _, int __) => const SizedBox(
          height: 10,
        ),
      );
    }

    return Container();
  }
}
