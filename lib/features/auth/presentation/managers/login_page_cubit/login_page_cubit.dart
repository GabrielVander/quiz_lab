import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_lab/features/auth/presentation/managers/login_page_cubit/view_models/login_page_view_model.dart';

part 'login_page_state.dart';

class LoginPageCubit extends Cubit<LoginPageState> {
  LoginPageCubit() : super(LoginPageState.initial());
}
