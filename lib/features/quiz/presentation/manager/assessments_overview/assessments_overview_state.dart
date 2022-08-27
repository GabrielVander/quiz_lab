part of 'assessments_overview_cubit.dart';

abstract class AssessmentsOverviewState extends Equatable {
  const AssessmentsOverviewState();
}

class AssessmentsOverviewInitial extends AssessmentsOverviewState {
  @override
  List<Object> get props => [];
}

class AssessmentsOverviewLoading extends AssessmentsOverviewState {
  @override
  List<Object> get props => [];
}

class AssessmentsOverviewLoaded extends AssessmentsOverviewState {
  const AssessmentsOverviewLoaded({
    required this.assessments,
  });

  final List<AssessmentOverviewModel> assessments;


  @override
  List<Object> get props => [assessments];
}

class AssessmentsOverviewError extends AssessmentsOverviewState {
  const AssessmentsOverviewError({
    required this.errorMessage,
  });

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
