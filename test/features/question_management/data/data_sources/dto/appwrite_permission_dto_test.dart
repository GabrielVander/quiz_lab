import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/dto/appwrite_permission_dto.dart';

void main() {
  group('AppwritePermissionRoleDto', () {
    group('toString', () {
      group(
        'should expected',
        () {
          for (final values in [
            [AppwritePermissionRoleDto.any(), 'any'],
            [AppwritePermissionRoleDto.guests(), 'guests'],
            [AppwritePermissionRoleDto.users(), 'users/verified'],
            [AppwritePermissionRoleDto.users(verified: false), 'users/unverified'],
            [AppwritePermissionRoleDto.user(userId: ''), 'user:/verified'],
            [AppwritePermissionRoleDto.user(userId: 'n7M!'), 'user:n7M!/verified'],
            [AppwritePermissionRoleDto.user(userId: 'Kt@L', verified: false), 'user:Kt@L/unverified'],
            [AppwritePermissionRoleDto.team(teamId: ''), 'team:'],
            [AppwritePermissionRoleDto.team(teamId: '0Wu61z'), 'team:0Wu61z'],
            [AppwritePermissionRoleDto.teamRole(teamId: '4TPasxC', role: ''), 'team:4TPasxC/'],
            [
              AppwritePermissionRoleDto.teamRole(
                teamId: r'w$a!2',
                role: 'n!Cr@*%',
              ),
              r'team:w$a!2/n!Cr@*%',
            ],
            [AppwritePermissionRoleDto.member(membershipId: ''), 'member:'],
            [AppwritePermissionRoleDto.member(membershipId: 'I%aY@'), 'member:I%aY@'],
          ]) {
            test(values.toString(), () {
              final model = values[0] as AppwritePermissionRoleDto;
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
            [AppwritePermissionTypeDto.read(AppwritePermissionRoleDto.any()), 'read("any")'],
            [
              AppwritePermissionTypeDto.read(AppwritePermissionRoleDto.user(userId: 'DZX')),
              'read("user:DZX/verified")',
            ],
            [AppwritePermissionTypeDto.create(AppwritePermissionRoleDto.guests()), 'create("guests")'],
            [
              AppwritePermissionTypeDto.create(AppwritePermissionRoleDto.member(membershipId: r'R$#AXdS5')),
              r'create("member:R$#AXdS5")',
            ],
            [AppwritePermissionTypeDto.update(AppwritePermissionRoleDto.team(teamId: '')), 'update("team:")'],
            [
              AppwritePermissionTypeDto.update(
                AppwritePermissionRoleDto.teamRole(
                  teamId: 'l9NzQ',
                  role: 'Kc8Ev',
                ),
              ),
              'update("team:l9NzQ/Kc8Ev")',
            ],
            [AppwritePermissionTypeDto.delete(AppwritePermissionRoleDto.users()), 'delete("users/verified")'],
            [
              AppwritePermissionTypeDto.delete(AppwritePermissionRoleDto.member(membershipId: 'P5y9CFp#')),
              'delete("member:P5y9CFp#")',
            ],
            [
              AppwritePermissionTypeDto.write(AppwritePermissionRoleDto.users(verified: false)),
              'write("users/unverified")',
            ],
            [
              AppwritePermissionTypeDto.write(
                AppwritePermissionRoleDto.user(
                  userId: r'7W$71',
                  verified: false,
                ),
              ),
              r'write("user:7W$71/unverified")',
            ],
          ]) {
            test(values.toString(), () {
              final model = values[0] as AppwritePermissionTypeDto;
              final expected = values[1] as String;

              expect(model.toString(), expected);
            });
          }
        },
      );
    });
  });
}
