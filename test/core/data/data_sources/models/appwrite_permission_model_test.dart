import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
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
                _FakeAppwritePermissionRoleModel(''),
              ),
              'read("")'
            ],
            [
              AppwritePermissionTypeModel.read(
                _FakeAppwritePermissionRoleModel('DZX'),
              ),
              'read("DZX")'
            ],
            [
              AppwritePermissionTypeModel.create(
                _FakeAppwritePermissionRoleModel(''),
              ),
              'create("")'
            ],
            [
              AppwritePermissionTypeModel.create(
                _FakeAppwritePermissionRoleModel(r'R$#AXdS5'),
              ),
              r'create("R$#AXdS5")'
            ],
            [
              AppwritePermissionTypeModel.update(
                _FakeAppwritePermissionRoleModel(''),
              ),
              'update("")'
            ],
            [
              AppwritePermissionTypeModel.update(
                _FakeAppwritePermissionRoleModel('l9NzQ'),
              ),
              'update("l9NzQ")'
            ],
            [
              AppwritePermissionTypeModel.delete(
                _FakeAppwritePermissionRoleModel(''),
              ),
              'delete("")'
            ],
            [
              AppwritePermissionTypeModel.delete(
                _FakeAppwritePermissionRoleModel('P5y9CFp#'),
              ),
              'delete("P5y9CFp#")'
            ],
            [
              AppwritePermissionTypeModel.write(
                _FakeAppwritePermissionRoleModel(''),
              ),
              'write("")'
            ],
            [
              AppwritePermissionTypeModel.write(
                _FakeAppwritePermissionRoleModel(r'7W$71'),
              ),
              r'write("7W$71")'
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

class _FakeAppwritePermissionRoleModel extends mocktail.Fake
    implements AppwritePermissionRoleModel {
  _FakeAppwritePermissionRoleModel(this.toStringValue);

  final String toStringValue;

  @override
  String toString() => toStringValue;
}
