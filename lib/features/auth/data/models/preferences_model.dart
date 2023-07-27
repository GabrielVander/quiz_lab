import 'package:appwrite/models.dart';
import 'package:equatable/equatable.dart';

class PreferencesModel extends Equatable {
  const PreferencesModel({
    required this.data,
  });

  factory PreferencesModel.fromAppwriteModel(Preferences appwriteModel) {
    return PreferencesModel(
      data: appwriteModel.data,
    );
  }

  final Map<String, dynamic> data;

  @override
  List<Object> get props => [data];
}
