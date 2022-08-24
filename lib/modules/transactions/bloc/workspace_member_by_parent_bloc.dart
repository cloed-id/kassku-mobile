import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kassku_mobile/models/member_workspace.dart';
import 'package:kassku_mobile/repositories/workspaces_repository.dart';
import 'package:kassku_mobile/utils/wrappers/error_wrapper.dart';

part 'workspace_member_by_parent_event.dart';
part 'workspace_member_by_parent_state.dart';

class WorkspaceMemberByParentBloc
    extends Bloc<WorkspaceMemberByParentEvent, WorkspaceMemberByParentState> {
  WorkspaceMemberByParentBloc() : super(WorkspaceMemberByParentInitial()) {
    on<FetchWorkspaceMemberByParent>(_fetchWorkspaceMemberByParent);
    on<SetBalanceWorkspaceMemberByParent>(_setBalanceWorkspaceMemberByParent);
    on<CreateWorkspaceMemberByParent>(_createWorkspaceMemberByParent);
  }

  final _repo = WorkspacesRepository();

  Future<void> _createWorkspaceMemberByParent(
    CreateWorkspaceMemberByParent event,
    Emitter<WorkspaceMemberByParentState> emit,
  ) async {
    emit(WorkspaceMemberByParentLoading(state));
    await ErrorWrapper.asyncGuard(
      () => _repo.addMemberToWorkspace(
        event.username,
        event.role,
        event.workspaceId,
      ),
      onError: (e) {
        emit(WorkspaceMemberByParentInitial());
      },
    ).then((value) {
      emit(WorkspaceMemberByParentSuccess(state.memberWorkspaces));
    }).catchError((e) {
      emit(WorkspaceMemberByParentInitial());
    });
  }

  Future<void> _fetchWorkspaceMemberByParent(
    FetchWorkspaceMemberByParent event,
    Emitter<WorkspaceMemberByParentState> emit,
  ) async {
    emit(WorkspaceMemberByParentLoading(state));
    final result = await ErrorWrapper.asyncGuard(
      () => _repo.getWorkspaceMemberbyParent(event.workspaceId, event.memberId),
      onError: (_) {
        emit(WorkspaceMemberByParentError(state, 'Kesalahan mendapatkan data'));
      },
    );

    final data = result.data as List<MemberWorkspace>;

    emit(WorkspaceMemberByParentLoaded(data));
  }

  Future<void> _setBalanceWorkspaceMemberByParent(
    SetBalanceWorkspaceMemberByParent event,
    Emitter<WorkspaceMemberByParentState> emit,
  ) async {
    emit(WorkspaceMemberByParentLoading(state));
    await ErrorWrapper.asyncGuard(
      () => _repo.setBalanceMember(
        event.memberId,
        event.workspaceId,
        event.amount,
      ),
      onError: (_) {
        emit(WorkspaceMemberByParentError(state, 'Kesalahan mendapatkan data'));
      },
    );

    emit(WorkspaceMemberByParentSetBalanceSuccess(state.memberWorkspaces));
    emit(WorkspaceMemberByParentLoaded(state.memberWorkspaces));
  }
}
