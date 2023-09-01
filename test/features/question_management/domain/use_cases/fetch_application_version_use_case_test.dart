import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:quiz_lab/features/question_management/domain/use_cases/fetch_application_version_use_case.dart';
import 'package:quiz_lab/features/question_management/wrappers/package_info_wrapper.dart';

void main() {
  late PackageInfoWrapper packageInfoWrapperMock;
  late FetchApplicationVersionUseCase useCase;

  setUp(() {
    packageInfoWrapperMock = _PackageInfoWrapperMock();
    useCase = FetchApplicationVersionUseCaseImpl(
      packageInfoWrapper: packageInfoWrapperMock,
    );
  });

  tearDown(mocktail.resetMocktailState);

  group(
    'should return value from package info wrapper',
    () {
      for (final value in [
        '',
        '6FS',
        '#7I',
      ]) {
        test(value, () {
          mocktail.when(() => packageInfoWrapperMock.applicationVersion).thenReturn(value);

          final result = useCase.execute();

          mocktail.verify(() => packageInfoWrapperMock.applicationVersion).called(1);
          expect(result, value);
        });
      }
    },
  );
}

class _PackageInfoWrapperMock extends mocktail.Mock implements PackageInfoWrapper {}
