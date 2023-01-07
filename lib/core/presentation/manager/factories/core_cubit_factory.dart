import 'package:quiz_lab/core/presentation/manager/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:quiz_lab/core/presentation/manager/network/network_cubit.dart';

class CoreCubitFactory {
  const CoreCubitFactory({
    required NetworkCubit networkCubit,
    required BottomNavigationCubit bottomNavigationCubit,
  })  : _networkCubit = networkCubit,
        _bottomNavigationCubit = bottomNavigationCubit;

  final NetworkCubit _networkCubit;
  final BottomNavigationCubit _bottomNavigationCubit;

  NetworkCubit makeNetworkCubit() => _networkCubit;

  BottomNavigationCubit makeBottomNavigationCubit() => _bottomNavigationCubit;
}
