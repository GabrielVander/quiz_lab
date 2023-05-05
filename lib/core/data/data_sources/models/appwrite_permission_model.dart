/// Appwrite Doc:
///
/// In Client and Server SDKs, you will find a Permission class with helper
/// methods for each role described below.
abstract class AppwritePermissionTypeModel {
  AppwritePermissionTypeModel._({required this.role});

  /// Appwrite Doc:
  ///
  /// Access to read a resource.
  factory AppwritePermissionTypeModel.read(AppwritePermissionRoleModel role) =>
      AppwritePermissionReadTypeModel._(role: role);

  /// Appwrite Doc:
  ///
  /// Access to create new resources. Does not apply to files or documents.
  /// Applying this type of access to files or documents results in an error.
  factory AppwritePermissionTypeModel.create(
    AppwritePermissionRoleModel role,
  ) =>
      AppwritePermissionCreateTypeModel._(role: role);

  /// Appwrite Doc:
  ///
  /// Access to change a resource, but not remove or create new resources. Does
  /// not apply to functions.
  factory AppwritePermissionTypeModel.update(
    AppwritePermissionRoleModel role,
  ) =>
      AppwritePermissionUpdateTypeModel._(role: role);

  /// Appwrite Doc:
  ///
  /// Access to remove a resource. Does not apply to functions.
  factory AppwritePermissionTypeModel.delete(
    AppwritePermissionRoleModel role,
  ) =>
      AppwritePermissionDeleteTypeModel._(role: role);

  /// Appwrite Doc:
  ///
  /// Alias to grant create, update, and delete access for collections and
  /// buckets and update and delete access for documents and files.
  factory AppwritePermissionTypeModel.write(AppwritePermissionRoleModel role) =>
      AppwritePermissionWriteTypeModel._(role: role);

  final AppwritePermissionRoleModel role;
}

class AppwritePermissionReadTypeModel extends AppwritePermissionTypeModel {
  AppwritePermissionReadTypeModel._({required super.role}) : super._();

  @override
  String toString() => 'read("$role")';
}

class AppwritePermissionCreateTypeModel extends AppwritePermissionTypeModel {
  AppwritePermissionCreateTypeModel._({required super.role}) : super._();

  @override
  String toString() => 'create("$role")';
}

class AppwritePermissionUpdateTypeModel extends AppwritePermissionTypeModel {
  AppwritePermissionUpdateTypeModel._({required super.role}) : super._();

  @override
  String toString() => 'update("$role")';
}

class AppwritePermissionDeleteTypeModel extends AppwritePermissionTypeModel {
  AppwritePermissionDeleteTypeModel._({required super.role}) : super._();

  @override
  String toString() => 'delete("$role")';
}

class AppwritePermissionWriteTypeModel extends AppwritePermissionTypeModel {
  AppwritePermissionWriteTypeModel._({required super.role}) : super._();

  @override
  String toString() => 'write("$role")';
}

/// Appwrite Docs:
///
/// In Client and Server SDKs, you will find a Role class with helper methods
/// for each role described below.
abstract class AppwritePermissionRoleModel {
  AppwritePermissionRoleModel._();

  /// Appwrite Docs:
  ///
  /// Grants access to anyone
  factory AppwritePermissionRoleModel.any() => AppwriteAnyPermissionModel._();

  /// Appwrite Docs:
  ///
  /// Grants access to any guest user without a session. Authenticated users
  /// don't have access to this role
  factory AppwritePermissionRoleModel.guests() =>
      AppwriteGuestsPermissionModel._();

  /// Appwrite Docs:
  ///
  /// Grants access to any authenticated or anonymous user. You can optionally
  /// pass the verified or unverified string to target specific types of users
  factory AppwritePermissionRoleModel.users({bool verified = true}) =>
      AppwriteUsersPermissionModel._(verified: verified);

  /// Appwrite Docs:
  ///
  /// Grants access to a specific user by user ID. You can optionally pass the
  /// verified or unverified string to target specific types of users
  factory AppwritePermissionRoleModel.user({
    required String userId,
    bool verified = true,
  }) =>
      AppwriteUserPermissionModel._(
        userId: userId,
        verified: verified,
      );

  /// Appwrite Docs:
  ///
  /// Grants access to any member of the specific team. To gain access to this
  /// permission, the user must be the team creator (owner), or receive and
  /// accept an invitation to join this team.
  factory AppwritePermissionRoleModel.team({required String teamId}) =>
      AppwriteTeamPermissionModel._(teamId: teamId);

  /// Appwrite Docs:
  ///
  /// Grants access to any member who possesses a specific role in a team. To
  /// gain access to this permission, the user must be a member of the specific
  /// team and have the given role assigned to them. Team roles can be assigned
  /// when inviting a user to become a team member.
  factory AppwritePermissionRoleModel.teamRole({
    required String teamId,
    required String role,
  }) =>
      AppwriteTeamRolePermissionMoedl._(
        teamId: teamId,
        role: role,
      );

  /// Appwrite Docs:
  ///
  /// Grants access to a specific member of a team. When the member is removed
  /// from the team, they will no longer have access.
  factory AppwritePermissionRoleModel.member({
    required String membershipId,
  }) =>
      AppwriteMemberPermissionModel._(
        membershipId: membershipId,
      );
}

class AppwriteAnyPermissionModel extends AppwritePermissionRoleModel {
  AppwriteAnyPermissionModel._() : super._();

  @override
  String toString() => 'any';
}

class AppwriteGuestsPermissionModel extends AppwritePermissionRoleModel {
  AppwriteGuestsPermissionModel._() : super._();

  @override
  String toString() => 'guests';
}

class AppwriteUsersPermissionModel extends AppwritePermissionRoleModel {
  AppwriteUsersPermissionModel._({required this.verified}) : super._();

  final bool verified;

  @override
  String toString() {
    final status = verified ? 'verified' : 'unverified';

    return 'users/$status';
  }
}

class AppwriteUserPermissionModel extends AppwritePermissionRoleModel {
  AppwriteUserPermissionModel._({required this.userId, required this.verified})
      : super._();

  final String userId;
  final bool verified;

  @override
  String toString() {
    final status = verified ? 'verified' : 'unverified';

    return 'user:$userId/$status';
  }
}

class AppwriteTeamPermissionModel extends AppwritePermissionRoleModel {
  AppwriteTeamPermissionModel._({required this.teamId}) : super._();

  final String teamId;

  @override
  String toString() => 'team:$teamId';
}

class AppwriteTeamRolePermissionMoedl extends AppwritePermissionRoleModel {
  AppwriteTeamRolePermissionMoedl._({required this.teamId, required this.role})
      : super._();

  final String teamId;
  final String role;

  @override
  String toString() => 'team:$teamId/$role';
}

class AppwriteMemberPermissionModel extends AppwritePermissionRoleModel {
  AppwriteMemberPermissionModel._({required this.membershipId}) : super._();

  final String membershipId;

  @override
  String toString() => 'member:$membershipId';
}
