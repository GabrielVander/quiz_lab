import 'package:appwrite/models.dart';
import 'package:equatable/equatable.dart';

class AppwritePreferencesDto extends Equatable {
  const AppwritePreferencesDto({
    required this.data,
  });

  factory AppwritePreferencesDto.fromAppwriteModel(Preferences model) => AppwritePreferencesDto(data: model.data);

  final Map<String, dynamic> data;

  @override
  List<Object> get props => [data];

  @override
  bool get stringify => false;

  @override
  String toString() => 'PreferencesModel{data: $data}';
}
