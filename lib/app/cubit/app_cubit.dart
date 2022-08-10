// ignore_for_file: unnecessary_statements, use_build_context_synchronously

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:kassku_mobile/helpers/user_helper.dart';
import 'package:kassku_mobile/models/user.dart';
import 'package:kassku_mobile/repositories/main_repository.dart';
import 'package:kassku_mobile/services/hive_service.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit(this.lang) : super(const AppLoading(null));

  final String lang;

  Future<void> init() async {
    emit(AppLoading(state.user));

    final _service = MainRepository();
    await _service.init(lang);

    final user = GetIt.I<HiveService>().getUser();

    GetIt.I<UserHelper>().lang = lang;

    emit(AppInitial(user));
  }
}
