import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_lab/core/data/data_sources/models/appwrite_permission_model.dart';

void main() {
  group('AppwritePermissionRoleModel', () {
    group('toString', () {
      group(
        'should expected',
        () {
          for (final values in [
            [AppwritePermissionRoleModel.any(), 'any'],
            [AppwritePermissionRoleModel.guests(), 'guests'],
            [AppwritePermissionRoleModel.users(), 'users/verified'],
            [
              AppwritePermissionRoleModel.users(verified: false),
              'users/unverified'
            ],
            [AppwritePermissionRoleModel.user(userId: ''), 'user:/verified'],
            [
              AppwritePermissionRoleModel.user(userId: 'n7M!'),
              'user:n7M!/verified'
            ],
            [
              AppwritePermissionRoleModel.user(userId: 'Kt@L', verified: false),
              'user:Kt@L/unverified'
            ],
            [AppwritePermissionRoleModel.team(teamId: ''), 'team:'],
            [AppwritePermissionRoleModel.team(teamId: '0Wu61z'), 'team:0Wu61z'],
            [
              AppwritePermissionRoleModel.teamRole(teamId: '4TPasxC', role: ''),
              'team:4TPasxC/'
            ],
            [
              AppwritePermissionRoleModel.teamRole(
                teamId: r'w$a!2',
                role: 'n!Cr@*%',
              ),
              r'team:w$a!2/n!Cr@*%'
            ],
            [AppwritePermissionRoleModel.member(membershipId: ''), 'member:'],
            [
              AppwritePermissionRoleModel.member(membershipId: 'I%aY@'),
              'member:I%aY@'
            ],
          ]) {
            test(values.toString(), () {
              final model = values[0] as AppwritePermissionRoleModel;
              final expected = values[1] as String;

              expect(model.toString(), expected);
            });
          }
        },
      );
    });
  });

  group('AppwritePermissionTypeModel', () {
    group('toString', () {
      group(
        'should return expected',
        () {
          for (final values in [
            [
              AppwritePermissionTypeModel.read(
                AppwritePermissionRoleModel.any(),
              ),
              'read("any")'
            ],
            [
              AppwritePermissionTypeModel.read(
                AppwritePermissionRoleModel.user(userId: 'DZX'),
              ),
              'read("user:DZX/verified")'
            ],
            [
              AppwritePermissionTypeModel.create(
                AppwritePermissionRoleModel.guests(),
              ),
              'create("guests")'
            ],
            [
              AppwritePermissionTypeModel.create(
                AppwritePermissionRoleModel.member(membershipId: r'R$#AXdS5'),
              ),
              r'create("member:R$#AXdS5")'
            ],
            [
              AppwritePermissionTypeModel.update(
                AppwritePermissionRoleModel.team(teamId: ''),
              ),
              'update("team:")'
            ],
            [
              AppwritePermissionTypeModel.update(
                AppwritePermissionRoleModel.teamRole(
                  teamId: 'l9NzQ',
                  role: 'Kc8Ev',
                ),
              ),
              'update("team:l9NzQ/Kc8Ev")'
            ],
            [
              AppwritePermissionTypeModel.delete(
                AppwritePermissionRoleModel.users(),
              ),
              'delete("users/verified")'
            ],
            [
              AppwritePermissionTypeModel.delete(
                AppwritePermissionRoleModel.member(membershipId: 'P5y9CFp#'),
              ),
              'delete("member:P5y9CFp#")'
            ],
            [
              AppwritePermissionTypeModel.write(
                AppwritePermissionRoleModel.users(verified: false),
              ),
              'write("users/unverified")'
            ],
            [
              AppwritePermissionTypeModel.write(
                AppwritePermissionRoleModel.user(
                  userId: r'7W$71',
                  verified: false,
                ),
              ),
              r'write("user:7W$71/unverified")'
            ],
          ]) {
            test(values.toString(), () {
              final model = values[0] as AppwritePermissionTypeModel;
              final expected = values[1] as String;

              expect(model.toString(), expected);
            });
          }
        },
      );
    });
  });
}
