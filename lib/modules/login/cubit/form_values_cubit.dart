import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'form_values_state.dart';

class FormValuesCubit extends Cubit<FormValuesState> {
  FormValuesCubit() : super(FormValuesState.initial());

  void setEmail(String email) {
    emit(state.copyWith(email: email));
  }

  void setPassword(String password) {
    emit(state.copyWith(password: password));
  }
}
