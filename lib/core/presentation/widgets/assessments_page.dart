import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:quiz_lab/core/presentation/manager/assessments_overview/assessments_overview_cubit.dart';
import 'package:quiz_lab/core/presentation/widgets/assessment_overview.dart';
import 'package:quiz_lab/core/presentation/widgets/fork_lift_message.dart';
import 'package:quiz_lab/core/presentation/widgets/page_subtitle.dart';
import 'package:quiz_lab/generated/l10n.dart';

class AssessmentsPage extends HookWidget {
  const AssessmentsPage({
    super.key,
    required this.assessmentsOverviewCubit,
  });

  final AssessmentsOverviewCubit assessmentsOverviewCubit;

  @override
  Widget build(BuildContext context) {
    final state = useBlocBuilder(assessmentsOverviewCubit);

    if (state is AssessmentsOverviewInitial) {
      assessmentsOverviewCubit.getAssessments(context);
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
              child:
                  ForkLiftMessage(message: S.of(context).workInProgressMessage),
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
