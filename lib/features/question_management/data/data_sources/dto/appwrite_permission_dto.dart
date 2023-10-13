import 'package:equatable/equatable.dart';

/// Appwrite Doc:
///
/// In Client and Server SDKs, you will find a Permission class with helper
/// methods for each role described below.
sealed class AppwritePermissionTypeDto extends Equatable {
  const AppwritePermissionTypeDto._({required this.role});

  /// Appwrite Doc:
  ///
  /// Access to read a resource.
  factory AppwritePermissionTypeDto.read(AppwritePermissionRoleDto role) => AppwritePermissionReadTypeDto._(role: role);

  /// Appwrite Doc:
  ///
  /// Access to create new resources. Does not apply to files or documents.
  /// Applying this type of access to files or documents results in an error.
  factory AppwritePermissionTypeDto.create(
    AppwritePermissionRoleDto role,
  ) =>
      AppwritePermissionCreateTypeDto._(role: role);

  /// Appwrite Doc:
  ///
  /// Access to change a resource, but not remove or create new resources. Does
  /// not apply to functions.
  factory AppwritePermissionTypeDto.update(
    AppwritePermissionRoleDto role,
  ) =>
      AppwritePermissionUpdateTypeDto._(role: role);

  /// Appwrite Doc:
  ///
  /// Access to remove a resource. Does not apply to functions.
  factory AppwritePermissionTypeDto.delete(
    AppwritePermissionRoleDto role,
  ) =>
      AppwritePermissionDeleteTypeDto._(role: role);

  /// Appwrite Doc:
  ///
  /// Alias to grant create, update, and delete access for collections and
  /// buckets and update and delete access for documents and files.
  factory AppwritePermissionTypeDto.write(AppwritePermissionRoleDto role) =>
      AppwritePermissionWriteTypeDto._(role: role);

  final AppwritePermissionRoleDto role;
}

class AppwritePermissionReadTypeDto extends AppwritePermissionTypeDto {
  const AppwritePermissionReadTypeDto._({required super.role}) : super._();

  @override
  String toString() => 'read("$role")';

  @override
  List<Object> get props => [role];
}

class AppwritePermissionCreateTypeDto extends AppwritePermissionTypeDto {
  const AppwritePermissionCreateTypeDto._({required super.role}) : super._();

  @override
  String toString() => 'create("$role")';

  @override
  List<Object> get props => [role];
}

class AppwritePermissionUpdateTypeDto extends AppwritePermissionTypeDto {
  const AppwritePermissionUpdateTypeDto._({required super.role}) : super._();

  @override
  String toString() => 'update("$role")';

  @override
  List<Object> get props => [role];
}

class AppwritePermissionDeleteTypeDto extends AppwritePermissionTypeDto {
  const AppwritePermissionDeleteTypeDto._({required super.role}) : super._();

  @override
  String toString() => 'delete("$role")';

  @override
  List<Object> get props => [role];
}

class AppwritePermissionWriteTypeDto extends AppwritePermissionTypeDto {
  const AppwritePermissionWriteTypeDto._({required super.role}) : super._();

  @override
  String toString() => 'write("$role")';

  @override
  List<Object> get props => [role];
}

/// Appwrite Docs:
///
/// In Client and Server SDKs, you will find a Role class with helper methods
/// for each role described below.
sealed class AppwritePermissionRoleDto extends Equatable {
  const AppwritePermissionRoleDto._();

  /// Appwrite Docs:
  ///
  /// Grants access to anyone
  factory AppwritePermissionRoleDto.any() => const AppwriteAnyPermissionDto._();

  /// Appwrite Docs:
  ///
  /// Grants access to any guest user without a session. Authenticated users
  /// don't have access to this role
  factory AppwritePermissionRoleDto.guests() => const AppwriteGuestsPermissionDto._();

  /// Appwrite Docs:
  ///
  /// Grants access to any authenticated or anonymous user. You can optionally
  /// pass the verified or unverified string to target specific types of users
  factory AppwritePermissionRoleDto.users({bool verified = true}) => AppwriteUsersPermissionDto._(verified: verified);

  /// Appwrite Docs:
  ///
  /// Grants access to a specific user by user ID. You can optionally pass the
  /// verified or unverified string to target specific types of users
  factory AppwritePermissionRoleDto.user({
    required String userId,
    bool verified = true,
  }) =>
      AppwriteUserPermissionDto._(
        userId: userId,
        verified: verified,
      );

  /// Appwrite Docs:
  ///
  /// Grants access to any member of the specific team. To gain access to this
  /// permission, the user must be the team creator (owner), or receive and
  /// accept an invitation to join this team.
  factory AppwritePermissionRoleDto.team({required String teamId}) => AppwriteTeamPermissionDto._(teamId: teamId);

  /// Appwrite Docs:
  ///
  /// Grants access to any member who possesses a specific role in a team. To
  /// gain access to this permission, the user must be a member of the specific
  /// team and have the given role assigned to them. Team roles can be assigned
  /// when inviting a user to become a team member.
  factory AppwritePermissionRoleDto.teamRole({
    required String teamId,
    required String role,
  }) =>
      AppwriteTeamRolePermissionDto._(
        teamId: teamId,
        role: role,
      );

  /// Appwrite Docs:
  ///
  /// Grants access to a specific member of a team. When the member is removed
  /// from the team, they will no longer have access.
  factory AppwritePermissionRoleDto.member({
    required String membershipId,
  }) =>
      AppwriteMemberPermissionDto._(
        membershipId: membershipId,
      );
}

class AppwriteAnyPermissionDto extends AppwritePermissionRoleDto {
  const AppwriteAnyPermissionDto._() : super._();

  @override
  String toString() => 'any';

  @override
  List<Object> get props => [];
}

class AppwriteGuestsPermissionDto extends AppwritePermissionRoleDto {
  const AppwriteGuestsPermissionDto._() : super._();

  @override
  String toString() => 'guests';

  @override
  List<Object> get props => [];
}

class AppwriteUsersPermissionDto extends AppwritePermissionRoleDto {
  const AppwriteUsersPermissionDto._({required this.verified}) : super._();

  final bool verified;

  @override
  String toString() {
    final status = verified ? 'verified' : 'unverified';

    return 'users/$status';
  }

  @override
  List<Object> get props => [verified];
}

class AppwriteUserPermissionDto extends AppwritePermissionRoleDto {
  const AppwriteUserPermissionDto._({
    required this.userId,
    required this.verified,
  }) : super._();

  final String userId;
  final bool verified;

  @override
  String toString() {
    final status = verified ? 'verified' : 'unverified';

    return 'user:$userId/$status';
  }

  @override
  List<Object> get props => [userId, verified];
}

class AppwriteTeamPermissionDto extends AppwritePermissionRoleDto {
  const AppwriteTeamPermissionDto._({required this.teamId}) : super._();

  final String teamId;

  @override
  String toString() => 'team:$teamId';

  @override
  List<Object> get props => [teamId];
}

class AppwriteTeamRolePermissionDto extends AppwritePermissionRoleDto {
  const AppwriteTeamRolePermissionDto._({
    required this.teamId,
    required this.role,
  }) : super._();

  final String teamId;
  final String role;

  @override
  String toString() => 'team:$teamId/$role';

  @override
  List<Object> get props => [teamId, role];
}

class AppwriteMemberPermissionDto extends AppwritePermissionRoleDto {
  const AppwriteMemberPermissionDto._({required this.membershipId}) : super._();

  final String membershipId;

  @override
  String toString() => 'member:$membershipId';

  @override
  List<Object> get props => [membershipId];
}
