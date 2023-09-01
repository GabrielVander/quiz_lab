import 'package:appwrite/models.dart';
import 'package:equatable/equatable.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/preferences_model.dart';

class UserModel extends Equatable {
  const UserModel({
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

  factory UserModel.fromAppwriteModel(User appwriteModel) => UserModel(
        $id: appwriteModel.$id != 'null' ? appwriteModel.$id : '',
        $createdAt: appwriteModel.$createdAt != 'null' ? appwriteModel.$createdAt : '',
        $updatedAt: appwriteModel.$updatedAt != 'null' ? appwriteModel.$updatedAt : '',
        name: appwriteModel.name != 'null' ? appwriteModel.name : '',
        registration: appwriteModel.registration != 'null' ? appwriteModel.registration : '',
        status: appwriteModel.status,
        passwordUpdate: appwriteModel.passwordUpdate != 'null' ? appwriteModel.passwordUpdate : '',
        email: appwriteModel.email != 'null' ? appwriteModel.email : '',
        phone: appwriteModel.phone != 'null' ? appwriteModel.phone : '',
        emailVerification: appwriteModel.emailVerification,
        phoneVerification: appwriteModel.phoneVerification,
        prefs: PreferencesModel.fromAppwriteModel(appwriteModel.prefs),
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
  final PreferencesModel prefs;

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
  String toString() => 'UserModel{'
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
