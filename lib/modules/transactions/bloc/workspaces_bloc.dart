import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kassku_mobile/models/workspace.dart';
import 'package:kassku_mobile/repositories/workspaces_repository.dart';
import 'package:kassku_mobile/utils/wrappers/error_wrapper.dart';

part 'workspaces_event.dart';

part 'workspaces_state.dart';

class WorkspacesBloc extends Bloc<WorkspacesEvent, WorkspacesState> {
  WorkspacesBloc() : super(WorkspacesInitial()) {
    on<FetchWorkspaces>(_searchWorkspaces);
    on<CreateWorkspace>(_createWorkspace);
    on<SelectWorkspace>(_selectWorkspace);
    on<FetchWorkspace>(_fetchWorkspace);
  }

  final _repo = WorkspacesRepository();

  Future<void> _fetchWorkspace(
    FetchWorkspace event,
    Emitter<WorkspacesState> emit,
  ) async {
    emit(WorkspacesLoading(state));
    final result = await ErrorWrapper.asyncGuard(
      () => _repo.getWorkspaceByMemberId(event.memberId),
      onError: (_) {
        emit(WorkspacesError(state, 'Kesalahan mendapatkan data'));
      },
    );

    final data = result.data as Workspace;

    final workspaces = state.workspaces;
    final index = workspaces.indexWhere((w) => w.id == data.id);
    workspaces[index] = data;

    emit(WorkspacesLoaded(workspaces, data));
  }

  void _selectWorkspace(
    SelectWorkspace event,
    Emitter<WorkspacesState> emit,
  ) {
    emit(WorkspacesLoading(state));
    emit(WorkspacesSelected(state.workspaces, event.workspace));
    emit(WorkspacesLoaded(state.workspaces, event.workspace));
  }

  Future<void> _searchWorkspaces(
    FetchWorkspaces event,
    Emitter<WorkspacesState> emit,
  ) async {
    emit(WorkspacesLoading(state));
    final result = await ErrorWrapper.asyncGuard(
      () => _repo.getWorkspaces(event.key),
      onError: (_) {
        emit(WorkspacesError(state, 'Error loading workspaces'));
      },
    );

    final data = result.data as List<Workspace>;

    emit(WorkspacesLoaded(data, data.first));
  }

  Future<void> _createWorkspace(
    CreateWorkspace event,
    Emitter<WorkspacesState> emit,
  ) async {
    emit(WorkspacesLoading(state));
    final result = await ErrorWrapper.asyncGuard(
      () => _repo.createWorkspace(event.name),
      onError: (_) {
        emit(WorkspacesLoaded(state.workspaces, state.selected));
        // emit(WorkspacesError(state, 'Error creating workspace'));
      },
    );

    final data = result.data as Workspace;

    emit(WorkspacesSuccess([data, ...state.workspaces], data));
    emit(WorkspacesLoaded(state.workspaces, state.selected));
  }
}
