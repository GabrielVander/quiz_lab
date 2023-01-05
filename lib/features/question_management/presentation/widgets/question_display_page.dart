import 'package:flutter/material.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/question_display/question_display_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/question_display/view_models/question_display_view_model.dart';

class QuestionDisplayPage extends StatelessWidget {
  const QuestionDisplayPage({
    super.key,
    required this.questionId,
    required this.cubit,
  });

  final QuestionDisplayCubit cubit;
  final String? questionId;

  @override
  Widget build(BuildContext context) {
    cubit.load();

    return StreamBuilder<QuestionDisplayState>(
        stream: cubit.stream,
        builder: (context, snapshot) {
          return Scaffold(
            body: Builder(builder: (context) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final state = snapshot.data!;

              if (state is QuestionDisplayInitial) {
                cubit.load();
              }

              if (state is QuestionDisplayViewModelSubjectUpdated) {
                return StreamBuilder<QuestionDisplayViewModel>(
                  stream: state.subject.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final viewModel = snapshot.data!;

                      return Text(viewModel.title);
                    }

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
          );
        });
  }
}
