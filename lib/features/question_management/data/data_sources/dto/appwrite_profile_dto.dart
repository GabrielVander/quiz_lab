import 'package:appwrite/models.dart';
import 'package:equatable/equatable.dart';

class AppwriteProfileDto extends Equatable {
  const AppwriteProfileDto({
    required this.id,
    required this.displayName,
  });

  factory AppwriteProfileDto.fromAppwriteDocument(Document doc) {
    return AppwriteProfileDto(
      id: doc.$id,
      displayName: doc.data['displayName'] as String?,
    );
  }

  final String id;
  final String? displayName;

  @override
  List<Object?> get props => [id, displayName];
}
