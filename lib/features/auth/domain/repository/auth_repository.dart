import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/auth/domain/entities/email_credentials.dart';

// ignore: one_member_abstracts
abstract class AuthRepository {
  Future<Result<Unit, String>> loginWithCredentions(
    EmailCredentials credentials,
  );
}
