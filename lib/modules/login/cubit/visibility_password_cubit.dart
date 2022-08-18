
import 'package:flutter_bloc/flutter_bloc.dart';

class VisibilityPasswordCubit extends Cubit<bool> {
  VisibilityPasswordCubit() : super(false);

  void toggle() => emit(!state);
}
