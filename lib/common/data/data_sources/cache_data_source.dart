import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/unit.dart';

abstract interface class CacheDataSource<T> {
  Future<Result<T, String>> fetchValue(String key);

  Future<Result<Unit, String>> storeValue(String key,  T value);
}
