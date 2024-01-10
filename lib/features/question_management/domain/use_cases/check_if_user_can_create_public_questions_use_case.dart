import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/features/question_management/domain/entities/current_user_session.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/auth_repository.dart';
import 'package:rust_core/result.dart';

// ignore: one_member_abstracts
abstract interface class CheckIfUserCanCreatePublicQuestionsUseCase {
  Future<Result<bool, String>> call();
}

class CheckIfUserCanCreatePublicQuestionsUseCaseImpl implements CheckIfUserCanCreatePublicQuestionsUseCase {
  CheckIfUserCanCreatePublicQuestionsUseCaseImpl({
    required this.logger,
    required this.authRepository,
  });

  final QuizLabLogger logger;
  final AuthRepository authRepository;

  static const sessionProvidersThatAreNotAllowed = [
    SessionProvider.anonymous,
    SessionProvider.unknown,
    null,
  ];

  @override
  Future<Result<bool, String>> call() async {
    logger.info('Executing...');

    return (await authRepository.getCurrentSession())
        .inspectErr(logger.error)
        .mapErr((_) => 'Unable to check if user can create public questions')
        .map(canCreatePublicQuestions);
  }

  bool canCreatePublicQuestions(CurrentUserSession? session) =>
      !sessionProvidersThatAreNotAllowed.contains(session?.provider);
}
