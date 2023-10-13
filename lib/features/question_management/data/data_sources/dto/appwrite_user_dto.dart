import 'package:appwrite/models.dart';
import 'package:equatable/equatable.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/dto/appwrite_preferences_dto.dart';

class AppwriteUserDto extends Equatable {
  const AppwriteUserDto({
    required this.$id,
    required this.$createdAt,
    required this.$updatedAt,
    required this.name,
    required this.registration,
    required this.status,
    required this.passwordUpdate,
    required this.email,
    required this.phone,
    required this.emailVerification,
    required this.phoneVerification,
    required this.prefs,
    this.password,
    this.hash,
    this.hashOptions,
  });

  factory AppwriteUserDto.fromAppwriteModel(User model) => AppwriteUserDto(
        $id: model.$id != 'null' ? model.$id : '',
        $createdAt: model.$createdAt != 'null' ? model.$createdAt : '',
        $updatedAt: model.$updatedAt != 'null' ? model.$updatedAt : '',
        name: model.name != 'null' ? model.name : '',
        registration: model.registration != 'null' ? model.registration : '',
        status: model.status,
        passwordUpdate: model.passwordUpdate != 'null' ? model.passwordUpdate : '',
        email: model.email != 'null' ? model.email : '',
        phone: model.phone != 'null' ? model.phone : '',
        emailVerification: model.emailVerification,
        phoneVerification: model.phoneVerification,
        prefs: AppwritePreferencesDto.fromAppwriteModel(model.prefs),
      );

  final String $id;
  final String $createdAt;
  final String $updatedAt;
  final String name;
  final String? password;
  final String? hash;
  final Map<dynamic, dynamic>? hashOptions;
  final String registration;
  final bool status;
  final String passwordUpdate;
  final String email;
  final String phone;
  final bool emailVerification;
  final bool phoneVerification;
  final AppwritePreferencesDto prefs;

  @override
  List<Object?> get props => [
        $id,
        $createdAt,
        $updatedAt,
        name,
        password,
        hash,
        hashOptions,
        registration,
        status,
        passwordUpdate,
        email,
        phone,
        emailVerification,
        phoneVerification,
        prefs,
      ];

  @override
  bool get stringify => false;

  @override
  String toString() => 'AppwriteUserDto{'
      '\$id: ${$id}, '
      '\$createdAt: ${$createdAt}, '
      '\$updatedAt: ${$updatedAt}, '
      'name: $name, '
      'password: $password, '
      'hash: $hash, '
      'hashOptions: $hashOptions, '
      'registration: $registration, '
      'status: $status, '
      'passwordUpdate: $passwordUpdate, '
      'email: $email, '
      'phone: $phone, '
      'emailVerification: $emailVerification, '
      'phoneVerification: $phoneVerification, '
      'prefs: $prefs'
      '}';
}
