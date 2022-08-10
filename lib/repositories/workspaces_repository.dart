import 'package:kassku_mobile/models/base_response.dart';
import 'package:kassku_mobile/models/workspace.dart';
import 'package:kassku_mobile/repositories/base_repository.dart';
import 'package:kassku_mobile/utils/constants.dart';
import 'package:kassku_mobile/utils/typedefs.dart';

class WorkspacesRepository extends BaseRepository {
  Future<BaseResponse<List<Workspace>>> getWorkspaces(String key) async {
    final response = await get(
      ApiEndPoint.kApiWorkspaces,
      queryParameters: <String, String>{
        // 'search_columns': 'name',
        // 'search_key': key,
        'page': '1',
        'per_page': '10',
      },
    );

    final result = responseWrapper<List<MapString>, MapString>(response);

    final transactions = result.map(Workspace.fromJson).toList();

    return BaseResponse.success(transactions);
  }

  Future<BaseResponse<Workspace>> createWorkspace(String name) async {
    final response = await post(
      ApiEndPoint.kApiWorkspaces,
      data: <String, dynamic>{
        'name': name,
      },
    );

    final result = responseWrapper<MapString, MapString>(response);

    final workspace = Workspace.fromJson(result);

    return BaseResponse.success(workspace);
  }
}
