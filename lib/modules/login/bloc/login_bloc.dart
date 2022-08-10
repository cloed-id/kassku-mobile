import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:kassku_mobile/helpers/navigation_helper.dart';
import 'package:kassku_mobile/repositories/auth_repository.dart';
import 'package:kassku_mobile/utils/wrappers/error_wrapper.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitEvent>(_loginSubmit);
  }

  final _repo = AuthRepository();

  Future<void> _loginSubmit(
    LoginSubmitEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    await ErrorWrapper.asyncGuard(
      () => _repo.submitLogin(event.email, event.password),
      onError: (e) {
        emit(LoginInitial());
      },
    );

    GetIt.I<NavigationHelper>().goToTransactions();
  }
}
