import 'package:get_it/get_it.dart';
import 'package:kassku_mobile/helpers/user_helper.dart';
import 'package:kassku_mobile/models/base_response.dart';
import 'package:kassku_mobile/models/category.dart';
import 'package:kassku_mobile/repositories/base_repository.dart';
import 'package:kassku_mobile/utils/constants.dart';
import 'package:kassku_mobile/utils/typedefs.dart';

class CategoriesRepository extends BaseRepository {
  Future<BaseResponse<List<Category>>> getCategories(
    String key,
    String workspaceId,
  ) async {
    final response = await get(
      '${ApiEndPoint.kApiWorkspaces}/$workspaceId/${ApiEndPoint.kApiCategories}',
      queryParameters: <String, String>{
        // 'search_columns': 'name',
        // 'search_key': key,
        'page': '1',
        'per_page': '10',
      },
    );

    final result = responseWrapper<List<MapString>, MapString>(response);

    final transactions = result.map(Category.fromJson).toList();

    return BaseResponse.success(transactions);
  }

  Future<BaseResponse<Category>> createCategory(
    String name,
    String workspaceId,
  ) async {
    final lang = GetIt.I<UserHelper>().lang;
    final response = await post(
      '${ApiEndPoint.kApiWorkspaces}/$workspaceId/${ApiEndPoint.kApiCategories}',
      data: <String, dynamic>{
        'name': name,
        'lang': lang,
      },
    );

    final result = responseWrapper<MapString, MapString>(response);

    final workspace = Category.fromJson(result);

    return BaseResponse.success(workspace);
  }
}
