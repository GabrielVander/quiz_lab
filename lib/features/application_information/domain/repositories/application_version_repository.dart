import 'package:rust_core/result.dart';

// ignore: one_member_abstracts
abstract interface class ApplicationVersionRepository {

  Future<Result<String, String>> fetchVersionName();

}
