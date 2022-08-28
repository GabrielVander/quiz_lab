import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';
import 'package:quiz_lab/features/quiz/presentation/manager/questions_overview/questions_overview_cubit.dart';
import 'package:quiz_lab/features/quiz/presentation/widgets/page_subtitle.dart';
import 'package:quiz_lab/features/quiz/presentation/widgets/question_overview.dart';

class QuestionsPage extends HookWidget {
  const QuestionsPage({
    super.key,
    required this.dependencyInjection,
  });

  final DependencyInjection dependencyInjection;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            children: const [
              PageSubtitle(title: 'Questions'),
            ],
          ),
          Expanded(
            child: Content(
              cubit: dependencyInjection.get<QuestionsOverviewCubit>(),
            ),
          ),
        ],
      ),
    );
  }
}

class Content extends HookWidget {
  const Content({
    super.key,
    required this.cubit,
  });

  final QuestionsOverviewCubit cubit;

  @override
  Widget build(BuildContext context) {
    final state = useBlocBuilder(cubit);

    if (state is QuestionsOverviewInitial) {
      cubit.getQuestions(context);
    }

    if (state is QuestionsOverviewLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is QuestionsOverviewLoaded) {
      final questions = state.questions;

      return ListView.separated(
        itemCount: questions.length,
        itemBuilder: (BuildContext context, int index) => Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
          background: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.red,
            ),
            alignment: Alignment.centerRight,
            child: Container(
              margin: const EdgeInsets.only(right: 15),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          ),
          child: QuestionOverview(
            question: questions[index],
          ),
        ),
        separatorBuilder: (BuildContext _, int __) => const SizedBox(
          height: 10,
        ),
      );
    }

    return Container();
  }
}
