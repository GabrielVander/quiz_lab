import 'package:quiz_lab/core/wrappers/package_info_wrapper.dart';

// ignore: one_member_abstracts
abstract class FetchApplicationVersionUseCase {
  String execute();
}

class FetchApplicationVersionUseCaseImpl implements FetchApplicationVersionUseCase {
  FetchApplicationVersionUseCaseImpl({required PackageInfoWrapper packageInfoWrapper})
      : _packageInfoWrapper = packageInfoWrapper;

  final PackageInfoWrapper _packageInfoWrapper;

  @override
  String execute() => _packageInfoWrapper.applicationVersion;
}
