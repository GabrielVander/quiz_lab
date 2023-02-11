import 'package:okay/okay.dart';
import 'package:quiz_lab/core/data/data_sources/appwrite_data_source.dart';
import 'package:quiz_lab/core/data/data_sources/models/email_session_credentials_model.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required AppwriteDataSource appwriteDataSource})
      : _appwriteDataSource = appwriteDataSource;

  final AppwriteDataSource _appwriteDataSource;

  @override
  Future<Result<Unit, AuthRepositoryError>> loginWithEmailCredentials(
    EmailCredentials credentials,
  ) async {
    final result = await _appwriteDataSource.createEmailSession(
      EmailSessionCredentialsModel(
        email: credentials.email,
        password: credentials.password,
      ),
    );

    if (result.isErr) {
      return Result.err(AuthRepositoryError.unexpected(message: result.err!));
    }

    return const Result.ok(unit);
  }
}
