import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:kassku_mobile/helpers/navigation_helper.dart';
import 'package:kassku_mobile/repositories/auth_repository.dart';
import 'package:kassku_mobile/utils/wrappers/error_wrapper.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterSubmitEvent>(_registerSubmit);
  }

  final _repo = AuthRepository();

  Future<void> _registerSubmit(
    RegisterSubmitEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());
    await ErrorWrapper.asyncGuard(
      () => _repo.submitRegister(event.email, event.password),
      onError: (e) {
        emit(RegisterInitial());
      },
    );

    GetIt.I<NavigationHelper>().goToTransactions();
  }
}
