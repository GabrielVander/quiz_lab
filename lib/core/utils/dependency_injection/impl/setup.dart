import 'package:quiz_lab/core/presentation/manager/network/network_cubit.dart';
import 'package:quiz_lab/core/utils/dependency_injection/dependency_injection.dart';

class CoreDiSetup implements DiSetup {
  @override
  void execute(DependencyInjection di) {
    di.registerBuilder((di) => NetworkCubit());
  }
}
