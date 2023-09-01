import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/appwrite_error_model.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/appwrite_profile_model.dart';

// ignore: one_member_abstracts
abstract interface class ProfileCollectionAppwriteDataSource {
  Future<Result<AppwriteProfileModel, AppwriteErrorModel>> fetchSingle(String id);
}

class ProfileCollectionAppwriteDataSourceImpl implements ProfileCollectionAppwriteDataSource {
  ProfileCollectionAppwriteDataSourceImpl({
    required this.logger,
    required this.databases,
    required this.appwriteDatabaseId,
    required this.appwriteProfileCollectionId,
  });

  final QuizLabLogger logger;
  final Databases databases;
  String appwriteDatabaseId;
  String appwriteProfileCollectionId;

  @override
  Future<Result<AppwriteProfileModel, AppwriteErrorModel>> fetchSingle(String id) async {
    logger.debug('Fetching single profile with id: $id from Appwrite...');

    return (await _performAppwriteFetch(id))
        .inspectErr((e) => logger.error(e.toString()))
        .mapErr(AppwriteErrorModel.fromAppwriteException)
        .map(AppwriteProfileModel.fromAppwriteDocument);
  }

  Future<Result<Document, AppwriteException>> _performAppwriteFetch(String id) async {
    try {
      return Ok(
        await databases.getDocument(
          databaseId: appwriteDatabaseId,
          collectionId: appwriteProfileCollectionId,
          documentId: id,
        ),
      );
    } on AppwriteException catch (e) {
      return Err(e);
    }
  }
}
