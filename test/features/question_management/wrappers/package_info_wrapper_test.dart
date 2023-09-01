import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:quiz_lab/features/question_management/wrappers/package_info_wrapper.dart';

void main() {
  late PackageInfo packageInfoMock;
  late PackageInfoWrapper wrapper;

  setUp(() {
    packageInfoMock = _PackageInfoMock();
    wrapper = PackageInfoWrapper(packageInfo: packageInfoMock);
  });

  group('applicationVersion', () {
    group(
      'should return expected',
      () {
        for (final version in [
          '',
          r'3&J*c8@$',
          'cN!',
        ]) {
          test(version, () {
            mocktail.when(() => packageInfoMock.version).thenReturn(version);

            final result = wrapper.applicationVersion;

            expect(result, version);

            mocktail.verify(() => packageInfoMock.version);
          });
        }
      },
    );
  });
}

class _PackageInfoMock extends mocktail.Mock implements PackageInfo {}
