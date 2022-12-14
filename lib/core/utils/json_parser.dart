import 'package:equatable/equatable.dart';
import 'package:okay/okay.dart';

class JsonParser<T extends Object> {
  JsonParser({required this.encoder, required this.decoder});

  final String Function(Object) encoder;
  final dynamic Function(String) decoder;

  Result<String, EncodeFailure> encode(T input) {
    try {
      encoder(input);
      return Result.ok(encoder(input));
      // ignore: avoid_catching_errors
    } on Exception catch (e) {
      return Result.err(EncodeFailure.exception(message: e.toString()));
    }
  }

  Result<T, DecodeFailure> decode(String input) {
    try {
      return Result.ok(decoder(input) as T);
      // ignore: avoid_catching_errors
    } on Exception catch (e) {
      return Result.err(DecodeFailure.exception(message: e.toString()));
    }
  }
}

abstract class EncodeFailure extends Equatable {
  const EncodeFailure._({required this.message});

  factory EncodeFailure.exception({
    required String message,
  }) =>
      _EncodeExceptionFailure._(exceptionMessage: message);

  final String message;

  @override
  List<Object> get props => [message];

  @override
  bool get stringify => true;
}

abstract class DecodeFailure extends Equatable {
  const DecodeFailure._({required this.message});

  factory DecodeFailure.exception({
    required String message,
  }) =>
      _DecodeExceptionFailure._(exceptionMessage: message);

  final String message;

  @override
  List<Object> get props => [message];

  @override
  bool get stringify => true;
}

class _EncodeExceptionFailure extends EncodeFailure {
  const _EncodeExceptionFailure._({required this.exceptionMessage})
      : super._(message: 'Unable to encode: $exceptionMessage');

  final String exceptionMessage;
}

class _DecodeExceptionFailure extends DecodeFailure {
  const _DecodeExceptionFailure._({required this.exceptionMessage})
      : super._(message: 'Unable to decode: $exceptionMessage');

  final String exceptionMessage;
}
