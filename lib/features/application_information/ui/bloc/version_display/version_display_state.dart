part of 'version_display_cubit.dart';

class VersionDisplayState extends Equatable {
  const VersionDisplayState({required this.version, required this.isLoading, this.errorCode});

  final String version;
  final bool isLoading;
  final String? errorCode;

  VersionDisplayState copyWith({
    String? version,
    bool? isLoading,
    String? errorCode,
  }) {
    return VersionDisplayState(
      version: version ?? this.version,
      isLoading: isLoading ?? this.isLoading,
      errorCode: errorCode ?? this.errorCode,
    );
  }

  @override
  List<Object?> get props => [version, isLoading, errorCode];
}
