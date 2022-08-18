import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FormKeyCubit extends Cubit<GlobalKey<FormState>> {
  FormKeyCubit() : super(GlobalKey<FormState>());

  void change() => emit(GlobalKey<FormState>());
}
