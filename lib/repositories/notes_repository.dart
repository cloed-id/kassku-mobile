import 'package:get_it/get_it.dart';
import 'package:kassku_mobile/helpers/analytics_helper.dart';
import 'package:kassku_mobile/helpers/user_helper.dart';
import 'package:kassku_mobile/models/base_response.dart';
import 'package:kassku_mobile/models/note.dart';
import 'package:kassku_mobile/repositories/base_repository.dart';
import 'package:kassku_mobile/utils/constants.dart';
import 'package:kassku_mobile/utils/enums.dart';
import 'package:kassku_mobile/utils/exceptions.dart';
import 'package:kassku_mobile/utils/typedefs.dart';

class NotesRepository extends BaseRepository {
  Future<BaseResponse<List<Note>>> getNotes(
    String key,
    String workspaceId,
    String memberWorkspaceId,
  ) async {
    final response = await get(
      '${ApiEndPoint.kApiWorkspaces}/$workspaceId/${ApiEndPoint.kApiNotes}',
      queryParameters: <String, String>{
        'member_workspace_id': memberWorkspaceId,
        'page': '1',
        'per_page': '10',
      },
    );

    final result = responseWrapper<List<MapString>, MapString>(response);

    final notes = result.map(Note.fromJson).toList();

    return BaseResponse.success(notes);
  }

  Future<BaseResponse<Note>> createNote(
    String workspaceId,
    String content,
    String memberWorkspaceId,
  ) async {
    final lang = GetIt.I<UserHelper>().lang;

    await AnalyticsHelper.logEvent(
      name: 'create_note',
      parameters: <String, dynamic>{
        'lang': lang,
      },
    );

    final response = await post(
      '${ApiEndPoint.kApiWorkspaces}/$workspaceId/${ApiEndPoint.kApiNotes}',
      data: <String, dynamic>{
        'content': content,
        'member_workspace_id': memberWorkspaceId,
        'lang': lang,
      },
    );

    final result = responseWrapper<MapString, MapString>(response);

    final note = Note.fromJson(result);

    return BaseResponse.success(note);
  }

  Future<void> deleteNote(
    String noteId,
    String workspaceId,
  ) async {
    await AnalyticsHelper.logEvent(name: 'delete_note');

    final response = await delete(
      '${ApiEndPoint.kApiWorkspaces}/$workspaceId/${ApiEndPoint.kApiNotes}/$noteId',
    );

    if (response.status == ResponseStatus.success) {
      return;
    }

    throw CustomExceptionString(response.message ?? 'Unknown error');
  }
}
