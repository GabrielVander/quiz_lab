part of 'network_cubit.dart';

abstract class NetworkState extends Equatable {
  const NetworkState();
}

class NetworkInitial extends NetworkState {
  @override
  List<Object> get props => [];
}

class NetworkChanged extends NetworkState {
  const NetworkChanged({
    required this.connected,
  });

  final bool connected;

  @override
  List<Object> get props => [
        connected,
      ];
}
