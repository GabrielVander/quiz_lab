import 'package:uuid/uuid.dart';

class ResourceUuidGenerator {
  const ResourceUuidGenerator({required this.uuid});

  final Uuid uuid;

  String generate() => uuid.v4();
}
