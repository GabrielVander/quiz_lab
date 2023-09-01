import 'package:appwrite/models.dart';
import 'package:equatable/equatable.dart';

class AppwriteProfileModel extends Equatable {
  const AppwriteProfileModel({
    required this.id,
    required this.displayName,
  });

  factory AppwriteProfileModel.fromAppwriteDocument(Document doc) {
    return AppwriteProfileModel(
      id: doc.$id,
      displayName: doc.data['displayName'] as String?,
    );
  }

  final String id;
  final String? displayName;

  @override
  List<Object?> get props => [id, displayName];
}
