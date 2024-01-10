import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:rust_core/result.dart';

abstract interface class CacheDataSource<T> {
  Future<Result<T, String>> fetchValue(String key);

  Future<Result<Unit, String>> storeValue(String key, T value);
}

class CacheDataSourceImpl<T> implements CacheDataSource<T> {
  CacheDataSourceImpl({required QuizLabLogger logger}) : _logger = logger;

  final QuizLabLogger _logger;
  final Map<String, T> _cache = {};

  @override
  Future<Result<T, String>> fetchValue(String key) async {
    _logger.debug('Fetching value for key: $key');

    if (!_cache.containsKey(key)) {
      return const Err('Key is not set');
    }

    return Ok<T, String>(_cache[key] as T);
  }

  @override
  Future<Result<Unit, String>> storeValue(String key, T value) async {
    _logger.debug('Storing value for key: $key');

    if(_cache.containsKey(key)) {
      return const Err('Key is already set');
    }

    _cache[key] = value;

    return const Ok<Unit, String>(unit);
  }
}
