import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:quiz_lab/core/utils/json_parser.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/hive_data_source.dart';

class DataSourceFactory {
  DataSourceFactory({
    required HiveInterface hiveInterface,
  }) : _hiveInterface = hiveInterface;

  final HiveInterface _hiveInterface;

  HiveDataSource makeHiveDataSource() {
    return HiveDataSource(
      questionsBox: _hiveInterface.box('questions'),
      jsonParser: JsonParser<Map<String, dynamic>>(
        decoder: jsonDecode,
        encoder: jsonEncode,
      ),
    );
  }
}
